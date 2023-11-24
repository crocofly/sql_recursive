CREATE TABLE arc (
    point1 char,
    point2 char,
    cost int,
    PRIMARY KEY(point1, point2)
);

/*
create table with routes
make all possible variants of gamiltonian cycles
count total weight of each path
*/

INSERT INTO arc VALUES ('a', 'b', 10);
INSERT INTO arc VALUES ('a', 'c', 15);
INSERT INTO arc VALUES ('a', 'd', 20);

INSERT INTO arc VALUES ('b', 'a', 10);
INSERT INTO arc VALUES ('b', 'c', 35);
INSERT INTO arc VALUES ('b', 'd', 25);

INSERT INTO arc VALUES ('c', 'a', 15);
INSERT INTO arc VALUES ('c', 'b', 35);
INSERT INTO arc VALUES ('c', 'd', 30);

INSERT INTO arc VALUES ('d', 'a', 20);
INSERT INTO arc VALUES ('d', 'b', 25);
INSERT INTO arc VALUES ('d', 'c', 30);

with recursive
    path (point1, total, tour, c)
        as (select arc.point1, 0 as total, cast(arc.point1 as text), 1
            from arc
            where arc.point1 = 'a'
            union
            select a.point2
                 , path.total + a.cost
                 , (path.tour || ',' || a.point2)
                 , path.c + 1
            from arc as a
                     inner join path on path.point1 = a.point1
            where path.tour not like ('%' || a.point2 || '%')),

    all_tours (total_cost, tour)
        as (select path.total + last.cost                          as total_cost,
                   ('{' || path.tour || ',' || last.point2 || '}') as tour
            from path
                     left join arc as last
                               on path.point1 = last.point1
            where last.point2 = 'a'
              and c = 4
            order by total_cost, tour)

select total_cost, tour
from all_tours
where total_cost = (select min(total_cost) from all_tours);

select total_cost, tour
from all_tours
where total_cost = (select min(total_cost) from all_tours) or total_cost = (select max(total_cost) from all_tours);
