use mywork;
select * from batter;

-- =======================================================================
-- [ Top 10 ]

-- 타율 
-- 1위 : 김태근 두산 0.5
select player, team, average from batter
order by average desc
limit 10;

-- 홈런 
-- 1위 : 박병호 KT 32
select player, team, HR from batter
order by HR desc
limit 10;

-- 장타율 
-- 1위 : 이재용 NC 0.8 
select player, team, SLG from batter
order by SLG desc
limit 10;

-- 득점 
-- 1위 : 피렐라 삼성 73
select player, team, R from batter
order by 3 desc
limit 10;

-- ==========================================================================
-- [ 개인 ]

-- 경기 대비 득점 비율 조회
-- 1위 : 피렐라 삼성 101 73 72.28
select player, team, G, R, round(R/G * 100,2) r_rate 
	from batter
	order by r_rate desc
    limit 10;

-- ==========================================================================
-- [ 팀별 ]

-- 팀별 홈런 평균 순위
select team, avg(HR) 
	from batter
    group by team
    order by 2 desc;
    
-- 팀별 경기 대비 득점 비율 조회
-- 1위 : LG 1180 529 44.83
select team, sum(G), sum(R), round(sum(R)/sum(G) * 100,2) r_rate
	from batter
    group by team
	order by r_rate desc
    limit 10;       











