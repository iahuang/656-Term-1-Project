print("Enter a string to be translated into nonsense.")
string = raw_input("")
y = ""
vowels1 = "aeiou"
vowels2 = vowels1.upper()
uppercase = "BCDFGHJKLMPQRSTVWXYZ"
lowercase = uppercase.lower()
for x in string:
    if x in vowels1:
        y = y + "v"
    elif x == " ":
        y = y + "_"
    elif x in vowels2:
        y = y + "V"
    elif x in uppercase:
        y = y + "C"
    elif x in lowercase:
        y = y + "c"
    else:
        y = y + "&"
print(y)