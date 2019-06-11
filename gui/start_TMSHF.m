clear all

global runtime_path
global resources_path

runtime_path = fullfile(fileparts(which('start_TMSHF')))
resources_path = fullfile(runtime_path, 'resources')

addpath(runtime_path)
addpath(fullfile(runtime_path, 'tools'))

clear
% clc

gui