--[[
Name:        log.lua
Usage:       lua log.lua
Commands:    exit, quit -> end logging
             view       -> takes a date in format YYYYMMDD and prints log for that day
             view today|yesterday -> prints relative log
Version:     1
Description:
A command line tool for taking notes during your day. Each note is timestamped in a log for that day.
]]

local lfs = require("lfs")

local LOG_DIR = "" -- specify directory to store log files 

local DATE_FORMAT = "%Y%m%d" -- YYYYMMDD
local TIME_FORMAT = "%X"     -- HH24:MM:SS

function file_exists(filename)
  for file in lfs.dir(LOG_DIR) do
    if file == filename then
      return true
    end
  end
  
  return false
end

function safe_open(filename, mode)
  local f = io.open(filename, mode)
  if not f then
    error("Could not open file: " .. filename .. " in mode: " .. mode)
  end
  
  return f
end

function create_file(filename)
  if file_exists(filename) then
    error("File already exists")
  end

  local f = safe_open(filename, "w")
  f:close()
  
  return filename
end

function get_todays_date()
  return os.date(DATE_FORMAT)
end

function get_todays_log()
  local today = get_todays_date()
  
  if file_exists(today) then
    return today
  else
    return create_file(today)
  end
end

function log_line(str, filename)
  if not file_exists(filename) then
    error("File " .. filename .. " does not exist.")
  end
  
  local file = safe_open(filename, "a")
  file:write("[" .. os.date(TIME_FORMAT) .. "] " .. str .. "\n")
  io.flush()
  file:close()
  
  return true
end

function print_log(logname)
  if not file_exists(logname) then
    print("\nLog " .. logname .. " does not exist.")
  else
    local logfile = safe_open(logname, "r")
    print("\nLog for date: " .. logname)
    print("----------------------")
    for line in logfile:lines() do
      print(line)
    end
  end
end

function parse_command(formatted_input)
  local view, log_date = string.match(formatted_input, '(%a+) (%d+)')
  if log_date then
    return log_date
  end
  
  local view, relative_date = string.match(formatted_input, '(%a+) (%a+)')
  if relative_date == "today" then
    return get_todays_date()
  elseif relative_date == "yesterday" then
    return (os.date(DATE_FORMAT, os.time() - 86400)) -- 1 day unix time
  end
  
  return nil
end

function starts_with(str, start)
   return str:sub(1, #start) == start
end

function run()
  if not lfs.chdir(LOG_DIR) then
    error("Unable to chdir to log dir.")
  end
  
  local today_log = get_todays_log()

  while true do
    io.write("\nlog >> ")
    local input = io.read("*l")
    local formatted_input = string.lower(input)
    
    if formatted_input == "exit" or
       formatted_input == "quit" then
       return 0
    elseif starts_with(formatted_input, "view") then
      local requested_date = parse_command(formatted_input)
      if requested_date then
        print_log(requested_date)
      end
    else
      if log_line(input, today_log) then
        io.write("logged")
      end
    end
  end
end

run()