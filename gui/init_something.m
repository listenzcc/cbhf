
global runtime_path

runtime_path = fullfile(fileparts(which('init_something')));

addpath(fullfile(runtime_path, 'tools'))

clear
clc