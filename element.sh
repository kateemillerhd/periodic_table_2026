#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]] 
then
  echo -e "Please provide an element as an argument."
  exit
fi

if [[ $1 =~ ^[0-9]+$ ]]
then
  # search using atomic number
  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $1")
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $1")
  ATOMIC_NUMBER=$1
  ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties ON types.type_id = properties.type_id WHERE atomic_number = $ATOMIC_NUMBER")

  echo -e "The element with atomic number $1 is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."

else
  # search using symbol/name
  NAME=$($PSQL "SELECT name FROM elements WHERE symbol = '$1' OR name = '$1'")
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$1' OR name = '$1'")
  NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1' OR name = '$1'")
  TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties ON types.type_id = properties.type_id WHERE atomic_number = $NUMBER")
  MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $NUMBER")
  BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $NUMBER")
  MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $NUMBER")


fi