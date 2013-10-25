
module(..., package.seeall)
require "sqlite3"

local path = system.pathForFile( "data.db", system.DocumentsDirectory )
local db = sqlite3.open( path )

ponto = 0
function createDataBase()
    
   -- local drop = "DROP TABLE IF EXISTS score"
    local tablesetup = [[CREATE TABLE IF NOT EXISTS score (id INTEGER PRIMARY KEY autoincrement, player, score INTEGER);]]
    --db:exec( drop )
    db:exec( tablesetup )
end

function insertScore()
    local query = [[INSERT INTO score VALUES (NULL, ']] .. "player1" .. [[',]] ..  ponto .. [[); ]]
    db:exec( query )
    
end

function getDb()
    return db
end



function closeDataBase()
    if (db and db:isopen()) then
     db:close()
    end 
end



    
