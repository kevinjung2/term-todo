#!/Users/kevin/.rbenv/versions/3.2.1/bin/ruby

require 'optparse'
require 'pg'

def show
  todo_tasks = DB.exec("SELECT task FROM todo WHERE status LIKE 'todo'")
  puts("\e[#{35}m#{"          TODO          "}\e[0m")
  puts("------------------------")
  todo_tasks.each do |row|
    puts("  - #{row['task']}")
  end
  puts ""
  working_tasks = DB.exec("SELECT task FROM todo WHERE status LIKE 'working'")  
  puts("\e[#{33}m#{"        WORKING        "}\e[0m")
  puts("------------------------")
  working_tasks.each do |row|
    puts("  - #{row['task']}")
  end  
  puts ""
  finished_tasks = DB.exec("SELECT task FROM todo WHERE status LIKE 'finished'")
  puts("\e[#{32}m#{"        FINSIHED        "}\e[0m")
  puts("------------------------")
  finished_tasks.each do |row|
    puts("  - #{row['task']}")
  end
  puts ""
  return
end

def add(task)
  DB.exec("INSERT INTO todo values ( '#{task}', 'todo')")
end

def move(task, status)
  DB.exec("UPDATE todo SET status='#{status}' WHERE task='#{task}'")
end

def sure_check(message)
  puts(message)
  puts "Y/N"
  input = gets.strip
  case input
  when "y", "Y", "yes", "Yes"
    return true
  when "n", "N", "no", "No"
    return false
  else
    puts("please enter either 'Y' or 'N'")
    sure_check(message)
  end
end

def clear()
  if sure_check("WARNING:: This action will clear all tasks in every section. Are you sure?")
    DB.exec("DELETE FROM todo")
  end
end

def remove(task)
  if sure_check("Do you want to delete #{task} from your todo board?")
    DB.exec("DELETE FROM todo WHERE task='#{task}'")
  end
end

def empty
  if sure_check("Delete all tasks from the finished section?")
    DB.exec("DELETE FROM todo WHERE status='finished'")
  end
end

OptionParser.new do |opts|
  #initialize db
    DB = PG.connect( dbname: 'todo')
    
  opts.banner = "Usage: todo [options]"

  opts.on("-s", "--show", "Shows all tasks currently on the list") do 
    show
  end
  opts.on("-a", "--add [TASK]", "Add TASK to todo list") do |task|
    add(task)
    show  
  end
  opts.on("-w", "--working [TASK]", "Move TASK to the working list") do |task|
    move(task, "working")
    show
  end
  opts.on("-f", "--finish [TASK]", "Move TASK to the finished list") do |task|
    move(task, "finished")
    show
  end
  opts.on("-r", "--remove [TASK]", "Remove TASK from list") do |task|
    remove(task)
    show
  end
 opts.on("-e", "--empty", "Empty Finished tasks") do
    empty
    show
  end
  opts.on("-c", "--clear", "Remove all tasks from todo list") do
    clear
    show
  end
end.parse!
