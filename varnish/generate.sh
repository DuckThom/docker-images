#!/bin/bash

ROOT_FOLDER=$(realpath $(dirname $0))
OUTPUT_FOLDER=$1
DOMAINS=$2

_realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

_color_red() {
  echo -n -e "\033[0;91m"
}

_color_yellow() {
  echo -n -e "\033[0;93m"
}

_color_green() {
  echo -n -e "\033[0;32m"
}

_color_magenta() {
  echo -n -e "\033[0;35m"
}

_color_reset() {
  echo -n -e "\033[0;39m"
}

usage() {
  DEV_SELF=$(basename $0);
  _color_yellow;
  echo "Usage ${DEV_SELF} <export path> <domains>";
  echo
  _color_green;
  echo "<export path> Export path"
  echo "<domains>     Domains, comma seperated (without spaces)"
  _color_reset;
  exit 255;

}

generate() {
  OUTPUT_FOLDER_REAL=$(realpath $OUTPUT_FOLDER)

  # Check if output folder is not empty
  if [ "$(ls -A $OUTPUT_FOLDER_REAL)" ]; then
    _color_red
    echo "DANGER: The given output folder ($OUTPUT_FOLDER_REAL) exists and is not empty!"
    _color_magenta
    read -p "Regenerate config in output folder?  [y/n]" -n 1 -r; echo
    _color_reset

    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        exit 0;
    fi

    # Clear output folder
    rm -rf $OUTPUT_FOLDER_REAL
  fi;

  # Force availabiliy of output folder
  mkdir -p $OUTPUT_FOLDER_REAL

  # Copy files to destination that are independent of domains
  mkdir -p $OUTPUT_FOLDER_REAL/hooks/backend
  mkdir -p $OUTPUT_FOLDER_REAL/hooks/client/_all
  cp -r $ROOT_FOLDER/hooks_tpl/backend/* $OUTPUT_FOLDER_REAL/hooks/backend/
  cp -r $ROOT_FOLDER/hooks_tpl/client/_all/* $OUTPUT_FOLDER_REAL/hooks/client/_all/

  # Copy domain specific but static content
  for DOMAIN in $(echo $DOMAINS | tr "," "\n"); do
    mkdir -p $OUTPUT_FOLDER_REAL/hooks/client/$DOMAIN
    cp -r $ROOT_FOLDER/hooks_tpl/client/_domain/* $OUTPUT_FOLDER_REAL/hooks/client/$DOMAIN/
  done

  # Generate default.vcl from template
  DOMAINS=$DOMAINS bash $ROOT_FOLDER/default_vcl.tpl > $OUTPUT_FOLDER_REAL/default.vcl
}

main() {
  if [[ -z $OUTPUT_FOLDER ]]; then
    usage;
  fi

  if [[ -z $DOMAINS ]]; then
    usage;
  fi

  generate;
}

main $@
