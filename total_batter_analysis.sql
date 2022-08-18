-- 1. 데이터 정제하기
-- (1) 불필요한 데이터 삭제하기 
-- 투수지만 타자로 지정된 선수들이 존재함 (타율0)
-- 투수 데이터 제거
SELECT * FROM batter; -- 타자지표
SELECT * FROM kbo_team; -- 팀 순위
SELECT * FROM kbo_win; -- 역대 우승팀
SELECT * FROM KBO_batter_teamrank; -- 역대 우승팀의 타자지표와 타자지표1위팀의 당시 순위
SELECT player, team, average
FROM batter
WHERE average = 0 
ORDER BY 2;

DELETE FROM batter
WHERE average = 0;

-- 2. 2022년 타율 조회하기
-- (1) 2022년 타율 TOP10 선수 조회(규정타석 이상)
SELECT player, team, average
FROM batter;
-- 규정타석 컬럼 추가
ALTER TABLE batter add MBR int;

UPDATE batter a INNER JOIN kbo_team b
ON a.team = b.팀명
SET a.MBR = b.경기*3.1;

SELECT player, team, average
FROM batter
WHERE PA>MBR
ORDER BY average DESC
LIMIT 10;

SELECT a.팀명,a.경기, COUNT(*)
FROM kbo_team a
INNER JOIN batter b
ON a.팀명 = b.team
GROUP BY a.팀명 WITH ROLLUP;

-- (2) 2022년 팀타율 조회(규정타석 이상)

SELECT a.팀명, a.경기, ROUND(AVG(b.average),5) average
FROM kbo_team a
INNER JOIN batter b
ON a.팀명 = b.team
GROUP BY a.팀명 
ORDER BY 3 DESC;

-- (3) 2022년 홈런 TOP10 선수 조회(규정타석 이상)
SELECT player, team, HR
FROM batter
WHERE PA>MBR
ORDER BY 3 DESC
LIMIT 10;

-- (4) 2022년 팀홈런 조회(규정타석 이상)

SELECT a.팀명, a.경기, SUM(b.HR) HomeRun
FROM kbo_team a
INNER JOIN batter b
ON a.팀명 = b.team
GROUP BY a.팀명 
ORDER BY 3 DESC;

-- (5) 2022년 OPS TOP10 선수 조회(규정타석 이상)
SELECT player, team, OPS
FROM batter
WHERE PA>MBR
ORDER BY 3 DESC
LIMIT 10;

-- (6) 2022년 팀OPS 조회(규정타석 이상)
SELECT a.팀명, a.경기, ROUND(AVG(b.OPS),5) OPS
FROM kbo_team a
INNER JOIN batter b
ON a.팀명 = b.team
GROUP BY a.팀명 
ORDER BY 3 DESC;

-- (7) 2022년 타자 GPA 지표 추가
-- GPA = ((1.8*출루율)+장타율) /4
-- GPA 컬럼 추가
ALTER TABLE batter add GPA double;
UPDATE batter 
SET GPA = ROUND(((1.8*OBP)+SLG)/4,3);

-- (8) 2022년 GPA TOP10 선수 조회(규정타석 이상)
SELECT player, team, GPA
FROM batter
WHERE PA>MBR
ORDER BY 3 DESC
LIMIT 10;

-- (9) 2022년 팀GPA 조회(규정타석 이상)
SELECT a.팀명, a.경기, ROUND(AVG(b.GPA),5) GPA
FROM kbo_team a
INNER JOIN batter b
ON a.팀명 = b.team
GROUP BY a.팀명 
ORDER BY 3 DESC;

-- (10) 역대 우승 팀 GPA 추가
ALTER TABLE kbo_win add GPA double;
UPDATE kbo_win 
SET GPA = ROUND(((1.8*obp)+slg)/4,3);

-- (11) 상관계수추가
-- AVG :0.44223990077118197  HR : 0.8132392741031201  OPS : 0.916055166009699
SELECT a.팀명, a.경기, ROUND(AVG(b.average),5) average
FROM kbo_team a
INNER JOIN batter b
ON a.팀명 = b.team
GROUP BY a.팀명 
ORDER BY 3 DESC;

CREATE TABLE CORR
(
	team	VARCHAR(30) NOT NULL,
	average DOUBLE,
    average_score DOUBLE,
    homerun INT,
    homerun_score DOUBLE,
    ops DOUBLE,
    ops_score DOUBLE,
    real_rank INT,
    ex_rank INT );
    
SELECT * FROM CORR;

INSERT INTO CORR (team,average,homerun,ops,real_rank) VALUES
ROW('SSG',0.21874,87,0.60143,1),
ROW('두산',0.23707,62,0.64354,8),
ROW('삼성',0.22668,64,0.58832,9),
ROW('KIA',0.26868,79,0.72274,5),
ROW('NC',0.2146,66,0.60616,7),
ROW('키움',0.21912,71,0.60952,3),
ROW('LG',0.25435,94,0.70165,2),
ROW('KT',0.24242,87,0.66754,4),
ROW('롯데',0.21868,75,0.58944,6),
ROW('한화',0.22438,74,0.61054,10);

INSERT INTO CORR (team)
SELECT 팀명 FROM kbo_team;

-- (12) -- 팀별 경기 대비 득점 비율 조회
-- 1위 : LG 1180 529 44.83
select team, sum(G), sum(R), round(sum(R)/sum(G) * 100,2) r_rate
	from batter
    group by team
	order by r_rate desc
    limit 10;    

-- (13) -- [ 개인 ]

-- 경기 대비 득점 비율 조회
-- 1위 : 피렐라 삼성 101 73 72.28
select player, team, G, R, round(R/G * 100,2) r_rate 
	from batter
	order by r_rate desc
    limit 10;
