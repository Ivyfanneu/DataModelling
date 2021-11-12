// Load file User
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/phongnnguyen/DataModelling/master/User.csv' AS user
MERGE(u:User { CIF: user.CIF, firstName: user.Fname, lastName: user.Lname, mobile: user.Mobile,
 email:user.Email, nationalID: user.NationalID, gender: user.Gender, birthYear: user.BirthYear, address: user.Address, district: user.District, cardNumber: user.CardNumber,groupID: user.GroupID})
RETURN u;


// Load file Group
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/phongnnguyen/DataModelling/master/group.csv' AS group
MERGE(g:Group { groupID: group.GroupID, groupName: group.GroupName,createAt: group.CreatedAt,teamLeadID: group.TeamleadID})
RETURN g;

// relationship between group and user
MATCH (g:Group),(u:User)
WHERE g.groupID = u.groupID
MERGE (g)<-[:Join_Group]-(u)
RETURN g, u;

//Load file Competition
 LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/phongnnguyen/DataModelling/master/Competition.csv' AS competition
MERGE(c:competition { CompetitionID: competition.CompetitionID,Week:competition.Week,Type:competition.Type})
RETURN c;


// create node join_competiton
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/Ivyfanneu/DataModelling/main/join_competition.csv' AS join_competition
MERGE(j:join_competition {UserID: join_competition.UserID,CompetitionID: join_competition.CompetitionID, Join_date:join_competition.Join_date})
RETURN j;

// relationship between competition, user and join_competition
MATCH (t1:User), (t2:competition), (t3:join_competition)
WHERE t1.CIF = t3.UserID AND t2.CompetitionID = t3.CompetitionID
MERGE (t1)-[:join_competition{join_at: t3.Join_date}]->(t2)
return t1, t2;

// create node run
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/Ivyfanneu/DataModelling/main/run.csv' AS run
MERGE(rn:run {UserID: run.UserID,CompetitionID: run.CompetitionID, Distance_record:run.Distance_record, Time_record: run.Time_record, Run_date:run.Run_date})
RETURN rn;

// relationship between competition, user and run
MATCH (t1:User), (t2:competition), (t3:run)
WHERE t1.CIF = t3.UserID AND t2.CompetitionID = t3.CompetitionID
MERGE (t1)-[:run{Distance_record: t3.Distance_record,Time_record: t3.Time_record,Run_date: t3.Run_date}]->(t2)
return t1, t2;

// rank relationship: competition rank users/groups

match (g:Group),(c:competition) 
where c.CompetitionID="1" and g.groupID="G04" 
create (g)<-[f:rank {postion: 1, product1:"cash",point1:10, product2:"adidas",point2:5, status:1}]-(c)
RETURN g,c,f;

match (g:Group),(c:competition) 
where c.CompetitionID="2" and g.groupID="G02" 
create (g)<-[f:rank {postion: 1, product1:"cash",point1:10, product2:"adidas",point2:5, status:1}]-(c)
RETURN g,c,f;

match (g:Group),(c:competition) 
where c.CompetitionID="2" and g.groupID="G04" 
create (g)<-[f:rank {postion: 2, product1:"cash",point1:10, status:1}]-(c)
RETURN g,c,f;

match (g:Group),(c:competition) 
where c.CompetitionID="3" and g.groupID="G05" 
create (g)<-[f:rank {postion: 1, product1:"cash",point1:10, product2:"adidas",point2:5, status:1}]-(c)
RETURN g,c,f;

match (u:User),(c:competition) 
where c.CompetitionID="4" and u.CIF="JN8AZ2KR4ET619566" 
create (u)<-[f:rank {postion: 1, product1:"cash",point1:10, product2:"adidas",point2:5, status:1}]-(c)
RETURN u,c,f;

match (u:User),(c:competition) 
where c.CompetitionID="4" and u.CIF="1GYUCFEJXAR387998" 
create (u)<-[f:rank {postion: 2, product1:"cash",point1:10, status:1}]-(c)
RETURN u,c,f;

match (u:User),(c:competition) 
where c.CompetitionID="4" and u.CIF="WAUKH68D11A680768" 
create (u)<-[f:rank {postion: 3, product1:"cash",point1:10, status:1}]-(c)
RETURN u,c,f;

match (u:User),(c:competition) 
where c.CompetitionID="5" and u.CIF="5N1CR2MN7EC654872" 
create (u)<-[f:rank {postion: 1, product1:"cash",point1:10, product2:"adidas",point2:5, status:1}]-(c)
RETURN u,c,f;

match (u:User),(c:competition) 
where c.CompetitionID="5" and u.CIF="JH4KB16677C844323" 
create (u)<-[f:rank {postion: 2, product1:"cash",point1:8, product2:"adidas",point2:5, status:1}]-(c)
RETURN u,c,f;

match (u:User),(c:competition) 
where c.CompetitionID="6" and u.CIF="1G4GE5G39CF298767" 
create (u)<-[f:rank {postion: 1, product1:"cash",point1:10, product2:"adidas",point2:5, status:1}]-(c)
RETURN u,c,f;

// Find specific userID info
MATCH (u:User) where u.firstname = "Rand"
Return u;

// Update userID info
MATCH (r:User) where r.CIF = "5FPYK1F5XEB038065"
SET r.address = "120 Road Avenue", r.district = "NY"
Return r;

// Find members of a group
MATCH (u:User)-[:Join_Group]->(g:Group)
where g.groupID = "G04"
Return u,g;

// Change the team lead of a group
MATCH (g:Group) where g.groupID = "G01"
SET g.teamLeadID = "WA1AY74L99D315003"
Return g;

// List out all user who have joined competition
MATCH (u:User)-[:join_competition]->(c:competition)
where c.CompetitionID = "4"
Return u,c;

// Show all users who join more than 1 competition
match (u:User)-[j:join_competition]->(c:competition)
WITH u,count(c) as joined_times, collect(c) as competitions
WHERE joined_times> 1
return u, competitions, joined_times;

// Count number of Female users in each group
match (u:User)-[:Join_Group]->(g:Group)
where u.gender = "f"
return g.groupID as GroupID,
count(u) as NoOfFemaleUsers;

// Count number of Male users in each group and sort in ascending order
match (u:User)-[:Join_Group]->(g:Group)
where u.gender = "m"
return g.groupID as GroupID,
count(u) as NoOfMaleUsers
order by NoOfMaleUsers;

// Lookup information of running
match (u:User)-[r:run]->(c:competition)
where u.CIF="JN8AZ2KR4ET619566" and c.CompetitionID="4"
return r.Distance_record, r.Time_record;

// Show top 3 users who have the best performance in term average running distance
match (u:User)-[r:run]->(c:competition)
return u.firstName as FirstName, avg(toInteger(r.Distance_record)) as Average_running_distance
order by Average_running_distance desc
limit 3;