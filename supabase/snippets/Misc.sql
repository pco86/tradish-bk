select title 
from traditions
inner join tradition_occurrences on title.id = tradition_occurrences.tradition_id
limit 10

