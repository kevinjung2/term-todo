# Term Todo
Term todo is a simple todo list application for the terminal. 
Create and move tasks between 'todo', 'working', and 'finished' categories.
## Simple usage
```todo -h```
## Dependencies
To run this application you need postgresql installed.
You must create a database named todo, and then create this table:
```
  CREATE TABLE todo (
    task text,
    status text
  );
```
you also need the ruby postgres gem which can be installed with:
```gem install pg```
## Installation
To install and run term-todo clone this repo and update ~/.zshrc or ~/.bashrc
with the line:  
```alias todo=PATH_TO_WHERE_YOU_CLONED/todo.rb```  
make sure that postgres is installed and you followed the steps in dependecies to create the todo database and table.
