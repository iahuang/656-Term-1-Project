#Definitions
import random
dlist = ['Ashe', 'Bastion', 'Doomfist', 'Genji', 'Hanzo', 'Junkrat', 'McCree', 'Mei', 'Pharah', 'Reaper', 'Soldier: 76', 'Sombra', 'Symmetra', 'Torbjorn', 'Tracer', 'Widowmaker']
tlist = ['D.Va', 'Orisa', 'Reinhardt', 'Roadhog', 'Winston', 'Wrecking Ball', 'Zarya']
slist = ['Ana', 'Brigitte', 'Lúcio', 'Mercy', 'Moira', 'Zenyatta']
def intro():
    print("Welcome to the Overwatch Random Hero Genetator. Please choose a hero type. (Damage, Tank, Support, or Anything")
    print('For a full hero list, type "List')
    userInput  = input("")
    userInput = userInput.lower()
    return userInput
#Main
intro()
if userInput == "list":
    print("The full list is...")
    print(dlist + tlist + slist)
    print("Pick a hero? (yes or no")
    userInput = input("")
    userInput = userInput.lower()
    if y in userInput:
        intro()
    else:
        print('Program terminated.')