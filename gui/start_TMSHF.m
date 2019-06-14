clear all

global gvar
gvar = struct;

gvar.runtime_path = fullfile(fileparts(which('start_TMSHF')))
gvar.resources_path = fullfile(gvar.runtime_path, 'resources')

addpath(gvar.runtime_path)
addpath(fullfile(gvar.runtime_path, 'tools'))

clear
% clc

gui