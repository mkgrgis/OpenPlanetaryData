#!/bin/sh
# Creates in a current directory a copy of USGS planeterynames data

# base structures: a list.
d="$PWD/OpenPlanetaryData";
mkdir "$d" 2>/dev/null;
f="$d/universal.json";
b="https://raw.githubusercontent.com/mkgrgis/OpenPlanetaryData/master";
usgsb="http://planetarynames.wr.usgs.gov/shapefiles";
wget -O - "$b/universal.json" 2> /dev/null > "$f";

# directories of planetery systems
n=$(cat "$f"| jq ".systeme|length");
dir=$(cat "$f"| jq ".systeme|keys");
for ((i=0; i < $n; i++)) do
  PlnInd=$(echo "$dir" | jq .[$i] | sed 's,",,g');
  mkdir "$d/$PlnInd";
done;

# data for planetes
for ((i=0; i < $n; i++)) do
  PlnInd=$(echo "$dir" | jq .[$i] | sed 's,",,g');
  planet=$(cat "$f"| jq ".systeme[\"$PlnInd\"]" | sed 's,",,g');
  echo "$PlnInd $planet";
  wget -O - "$usgsb/${planet}_nomenclature.zip" 2> /dev/null > "$d/$PlnInd/${planet}_nomenclature.zip";
done;
echo;

# data for satellites
n=$(cat "$f"| jq ".element|length");
dir=$(cat "$f"| jq ".element|keys");
for ((i=0; i < $n; i++)) do
  planet=$(echo "$dir" | jq .[$i] | sed 's,",,g');
  dirPln=$(cat "$f"| jq ".element[\"$planet\"]" | sed 's,",,g');
  echo "$dirPln $planet";
  wget -O - "$usgsb/${planet}_nomenclature.zip" 2> /dev/null > "$d/$dirPln/${planet}_nomenclature.zip";
done;

