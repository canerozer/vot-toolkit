function [document, scores] = report_failures(context, experiment, trackers, sequences, varargin)
% report_failures Generate a statistic overview of occurences of failures
%
% Generate a statistic overview of occurences of failures in individual sequences.
%
% Input:
% - context (structure): Report context structure.
% - experiment (struct): An experiment structure.
% - trackers (cell): An array of tracker structures.
% - sequences (cell): An array of sequence structures.
%
% Output:
% - document (structure): Resulting document structure.
%
if is_octave
    experiment = cell2mat(experiment);
end

scores = [];

document = document_create(context, 'failures', 'title', 'Failure overview');

for i = 1:2:length(varargin)
    switch lower(varargin{i})
        otherwise
            error(['Unknown switch ', varargin{i},'!']) ;
    end
end

tracker_labels = cellfun(@(x) iff(isfield(x.metadata, 'verified') && x.metadata.verified, [x.label, '*'], x.label), trackers, 'UniformOutput', 0);

sequences_hash = md5hash(strjoin((cellfun(@(x) x.name, sequences, 'UniformOutput', false)), '-'), 'Char', 'hex');
trackers_hash = md5hash(strjoin((cellfun(@(x) x.identifier, trackers, 'UniformOutput', false)), '-'), 'Char', 'hex');

if ~strcmp(experiment.type, 'supervised')
   error('Failure analysis only suitable for supervised experiments!');
end

cache_identifier = sprintf('failures_%s_%s_%s.mat', experiment.name, trackers_hash, sequences_hash);

histograms = document_cache(context, cache_identifier, @analyze_failures, ...
    experiment, trackers, sequences);

document.subsection('Experiment %s', experiment.name);

experiment_sequences = convert_sequences(sequences, experiment.converter);

for s = 1:length(experiment_sequences)

    if numel(experiment_sequences{s}.tags.names) == 0
        continue
    end

    document.subsection('Sequence %s',  experiment_sequences{s}.name);

    document.raw('<div class="imagegrid">\n');

    hf = figure('Visible', 'off');
    imagesc(histograms{s});
    set(gca,'ytick',(1:numel(trackers)),'yticklabel', tracker_labels);

    document.figure(hf, sprintf('failures_%s_%s_individual', experiment.name, experiment_sequences{s}.name), ...
        sprintf('Sequence %s, individual trackers', experiment_sequences{s}.name));

    hf = figure('Visible', 'off');
    tags = experiment_sequences{s}.tags.data;
    tagsplit = mat2cell(tags, size(tags, 1), ones(1, size(tags, 2)));
    starts = cellfun(@(x) find(diff([0; x; 0]) > 0), tagsplit, 'UniformOutput', 0);
    ends = cellfun(@(x) find(diff([0; x; 0]) < 0), tagsplit, 'UniformOutput', 0);

    hold on;
    plot_timeline(experiment_sequences{s}.tags.names, starts, ends);
    combined_histogram = sum(histograms{s}, 1);
    combined_histogram = (combined_histogram / max(combined_histogram)) * numel(experiment_sequences{s}.tags.names);
    plot(combined_histogram);
    set(gca, 'XLim', [1, experiment_sequences{s}.length]);
    hold off;

    document.figure(hf, sprintf('failures_%s_%s_combined', experiment.name, experiment_sequences{s}.name), ...
        sprintf('Sequence %s, combined failures with properties', experiment_sequences{s}.name));

    document.raw('</div>\n');
end;

document.write();

