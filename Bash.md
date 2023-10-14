# YesNo

```bash
read -p "Do you want to proceed? (y/n) " yn

case $yn in 
	[yY] ) echo ok, we will proceed;
		break;;
	[nN] ) echo exiting...;
		exit;;
	* ) echo invalid response;;
esac
```

# Yes 

```bash
read -p "Do you want to proceed? (y/N) " yn

if [[ $yn =~ [yY](es)* ]]
then
   echo proceed
fi
```

# Remove empty lines

```bash
command-here | tr -d '\n'
```
# String checks
```bash
if [ -n "$var" ]; then # if string not empty
if [ -z "$var" ]; then # if string is empty
```

# For loop
```bash
authors=("author1" "author2" "author3")
for i in ${authors[@]}
do
    echo $i
done
```

# String start with character
```bash
if [[ $var == c* ]]; then
  echo "var starts with 'c'";
fi
