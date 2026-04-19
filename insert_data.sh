#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # prevent inserting headers
  if [[ $WINNER != "winner" ]]
  then
    # get winner team_id
    WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # get opponent team_id
    OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # if winner team_id not found
    if [[ -z $WINNER_TEAM_ID ]]
    then
      # insert winner team
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER winner
      fi
      # get new winner team_id
      WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      WINNER_TEAM_IN_TABLE=$($PSQL "SELECT name FROM teams WHERE team_id =$WINNER_TEAM_ID")
    fi

    if [[ -z $OPPONENT_TEAM_ID ]]
      then  
        # insert opponent team
        INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
        then
          echo Inserted into teams, $OPPONENT opponent
        fi
        # get new opponent team_id
        OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
        OPPONENT_TEAM_IN_TABLE=$($PSQL "SELECT name FROM teams WHERE team_id =$OPPONENT_TEAM_ID") 
    fi
  fi
done
