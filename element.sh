#! /bin/bash

# Connection settings
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if the script has an input argument
if [[ -z $1 ]]
then
  # No argument has been passed to the script
  echo "Please provide an element as an argument."
else
  # Check if the argument is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$1
    NAME=$($PSQL "SELECT name FROM properties JOIN elements USING(atomic_number) WHERE atomic_number = $ATOMIC_NUMBER")
    SYMBOL=$($PSQL "SELECT symbol FROM properties JOIN elements USING(atomic_number) WHERE atomic_number = $ATOMIC_NUMBER")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    MELTING_POINT_CELSIUS=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    BOILING_POINT_CELSIUS=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    TYPE=$($PSQL "SELECT type FROM properties JOIN types USING(type_id) WHERE atomic_number = $ATOMIC_NUMBER")
  fi

  # Check if the input is passing symbol name as argument
  if [[ $1 =~ ^[a-zA-Z]{1,2}$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'")
    NAME=$($PSQL "SELECT name FROM elements WHERE symbol = '$1'")
    SYMBOL=$1
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM elements JOIN properties USING(atomic_number) WHERE symbol = '$1'")
    MELTING_POINT_CELSIUS=$($PSQL "SELECT melting_point_celsius FROM elements JOIN properties USING(atomic_number) WHERE symbol = '$1'")
    BOILING_POINT_CELSIUS=$($PSQL "SELECT boiling_point_celsius FROM elements JOIN properties USING(atomic_number) WHERE symbol = '$1'")
    TYPE=$($PSQL "SELECT type FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE symbol = '$1'")
  fi

  # Check if the input is passing element full name as argument
  if [[ $1 =~ ^[a-zA-Z]{3,}$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1'")
    NAME=$1
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name = '$1'")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM elements JOIN properties USING(atomic_number) WHERE name = '$1'")
    MELTING_POINT_CELSIUS=$($PSQL "SELECT melting_point_celsius FROM elements JOIN properties USING(atomic_number) WHERE name = '$1'")
    BOILING_POINT_CELSIUS=$($PSQL "SELECT boiling_point_celsius FROM elements JOIN properties USING(atomic_number) WHERE name = '$1'")
    TYPE=$($PSQL "SELECT type FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE name = '$1'")
  fi

  # Print the output
  echo -e "\nThe element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $SYMBOL has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
fi
