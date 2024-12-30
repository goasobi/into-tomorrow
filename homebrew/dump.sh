#!/bin/sh

mv Brewfile Brewfile.bak && brew bundle dump && rm Brewfile.bak
