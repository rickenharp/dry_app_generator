#!/bin/sh

echo 'Installing gems'
bundle install

if [ ! -f .env ]; then
    echo 'Copying example .env file'
    cp .env.example .env
fi