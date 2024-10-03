#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

$($PSQL "TRUNCATE TABLE games, teams;")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[  $WINNER != "winner" ]]
  then
    #get team_id WINNER
    TEAM_ID_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    echo $TEAM_ID_WINNER
    #if not found
    if [[ -z $TEAM_ID_WINNER ]]
    then
    #insert team from winners column
    INSERT_TEAM_W=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    echo $INSERT_TEAM_W
    #get new team_id
    TEAM_ID_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi
    
    #get team_id OPPONENT
    TEAM_ID_OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    echo $TEAM_ID_OPPONENT
    #if not found
    if [[ -z $TEAM_ID_OPPONENT ]]
    then
    #insert team from opponents column
    INSERT_TEAM_O=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    echo $INSERT_TEAM_O
    #get new team id
    TEAM_ID_OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi
    INSERT_GAMES=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$TEAM_ID_WINNER,$TEAM_ID_OPPONENT,$WINNER_GOALS,$OPPONENT_GOALS)")
  fi

  
done