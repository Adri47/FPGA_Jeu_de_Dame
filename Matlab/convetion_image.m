clear;
clc;
close all

img = imread('damier_redif.png');
A = reshape(img', 1,[]); %on transpose img et on récupère le vecteur ligne


D(A==0) = strcat("111")
D(A==1) = strcat("000")
