
CREATE SCHEMA apple_music;

use apple_music;

-- Users 테이블 (사용자 정보)
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT, -- 사용자 고유 ID (자동 증가)
    username VARCHAR(50) NOT NULL UNIQUE,   -- 사용자명 (중복 불가)
    email VARCHAR(100) NOT NULL UNIQUE,     -- 이메일 (중복 불가)
    password VARCHAR(255) NOT NULL,         -- 비밀번호 (암호화 저장)
    full_name VARCHAR(100),                 -- 실명
    birth_date DATE,                        -- 생년월일
    country VARCHAR(50),                    -- 국가
    registration_date DATETIME DEFAULT CURRENT_TIMESTAMP, -- 가입일
    last_login DATETIME                     -- 마지막 로그인 시간
);

-- Artists 테이블 (아티스트 정보)
CREATE TABLE Artists (
    artist_id INT PRIMARY KEY AUTO_INCREMENT, -- 아티스트 고유 ID
    artist_name VARCHAR(100) NOT NULL,        -- 아티스트명
    biography TEXT,                           -- 약력
    debut_year INT,                           -- 데뷔 연도
    country VARCHAR(50)                       -- 국가
);

-- Albums 테이블 (앨범 정보)
CREATE TABLE Albums (
    album_id INT PRIMARY KEY AUTO_INCREMENT, -- 앨범 고유 ID
    album_title VARCHAR(200) NOT NULL,       -- 앨범 제목
    artist_id INT NOT NULL,                  -- 아티스트 ID (외래키)
    release_date DATE,                       -- 발매일
    genre VARCHAR(50),                       -- 장르
    album_cover_url VARCHAR(255),            -- 앨범 커버 이미지 URL
    FOREIGN KEY (artist_id) REFERENCES Artists(artist_id) -- 아티스트와의 관계 설정
);

-- Songs 테이블 (노래 정보)
CREATE TABLE Songs (
    song_id INT PRIMARY KEY AUTO_INCREMENT, -- 노래 고유 ID
    song_title VARCHAR(200) NOT NULL,       -- 노래 제목
    album_id INT,                           -- 앨범 ID (외래키)
    artist_id INT NOT NULL,                 -- 아티스트 ID (외래키)
    duration INT NOT NULL,                  -- 재생 시간(초)
    track_number INT,                       -- 트랙 번호
    release_date DATE,                      -- 발매일
    genre VARCHAR(50),                      -- 장르
    play_count INT DEFAULT 0,               -- 재생 횟수
    FOREIGN KEY (album_id) REFERENCES Albums(album_id),
    FOREIGN KEY (artist_id) REFERENCES Artists(artist_id)
);

-- Playlists 테이블 (재생목록 정보)
CREATE TABLE Playlists (
    playlist_id INT PRIMARY KEY AUTO_INCREMENT, -- 재생목록 고유 ID
    playlist_name VARCHAR(100) NOT NULL,        -- 재생목록 이름
    user_id INT NOT NULL,                       -- 생성한 사용자 ID
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP, -- 생성일
    is_public BOOLEAN DEFAULT FALSE,            -- 공개 여부
    description TEXT,                           -- 설명
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- PlaylistSongs 테이블 (재생목록에 포함된 노래)
CREATE TABLE PlaylistSongs (
    playlist_id INT,                  -- 재생목록 ID
    song_id INT,                      -- 노래 ID
    added_date DATETIME DEFAULT CURRENT_TIMESTAMP, -- 추가일
    position INT,                     -- 재생목록 내 위치
    PRIMARY KEY (playlist_id, song_id), -- 복합 기본키
    FOREIGN KEY (playlist_id) REFERENCES Playlists(playlist_id),
    FOREIGN KEY (song_id) REFERENCES Songs(song_id)
);

-- Likes 테이블 (좋아요 정보)
CREATE TABLE Likes (
    user_id INT,                      -- 사용자 ID
    content_type ENUM('song', 'album', 'artist', 'playlist'), -- 좋아요 대상 유형
    content_id INT,                   -- 좋아요 대상 ID
    liked_date DATETIME DEFAULT CURRENT_TIMESTAMP, -- 좋아요 날짜
    PRIMARY KEY (user_id, content_type, content_id), -- 복합 기본키
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- UserSubscriptions 테이블 (구독 정보)
CREATE TABLE UserSubscriptions (
    subscription_id INT PRIMARY KEY AUTO_INCREMENT, -- 구독 고유 ID
    user_id INT NOT NULL,                          -- 사용자 ID
    subscription_type VARCHAR(20) NOT NULL,        -- 구독 유형(무료, 개인, 가족 등)
    start_date DATE NOT NULL,                      -- 시작일
    end_date DATE,                                 -- 종료일
    payment_method VARCHAR(50),                    -- 결제 수단
    auto_renewal BOOLEAN DEFAULT TRUE,             -- 자동 갱신 여부
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Users 테이블에 샘플 데이터 추가
INSERT INTO Users (username, email, password, full_name, birth_date, country) VALUES
('music_lover', 'music@example.com', 'hashed_password123', '김음악', '1990-05-15', '대한민국'),
('k_pop_fan', 'kpop@example.com', 'hashed_password456', '박케이팝', '1995-08-22', '대한민국'),
('rock_star', 'rock@example.com', 'hashed_password789', 'John Rock', '1985-12-10', '미국'),
('jazz_girl', 'jazz@example.com', 'hashed_passwordabc', 'Sarah Jazz', '1988-03-28', '영국'),
('indie_boy', 'indie@example.com', 'hashed_passworddef', '이인디', '1992-07-19', '대한민국'),
('classic_master', 'classic@example.com', 'hashed_passwordghi', 'Maria Classic', '1980-01-05', '이탈리아'),
('hiphop_king', 'hiphop@example.com', 'hashed_passwordjkl', '정힙합', '1993-11-14', '대한민국'),
('pop_queen', 'pop@example.com', 'hashed_passwordmno', 'Lisa Pop', '1991-09-30', '미국'),
('edm_dj', 'edm@example.com', 'hashed_passwordpqr', '최이디엠', '1994-06-25', '대한민국'),
('ballad_lover', 'ballad@example.com', 'hashed_passwordstu', '한발라드', '1987-02-17', '대한민국');

-- Artists 테이블에 샘플 데이터 추가
INSERT INTO Artists (artist_name, biography, debut_year, country) VALUES
('BTS', '방탄소년단(BTS)은 빅히트 엔터테인먼트 소속의 7인조 보이 그룹입니다.', 2013, '대한민국'),
('아이유', '아이유는 대한민국의 솔로 가수이자 배우입니다.', 2008, '대한민국'),
('Adele', 'Adele Laurie Blue Adkins는 영국의 싱어송라이터입니다.', 2006, '영국'),
('Bruno Mars', 'Peter Gene Hernandez는 미국의 싱어송라이터이자 레코드 프로듀서입니다.', 2004, '미국'),
('블랙핑크', '블랙핑크는 YG 엔터테인먼트 소속의 4인조 걸 그룹입니다.', 2016, '대한민국'),
('Coldplay', 'Coldplay는 영국의 록 밴드입니다.', 1996, '영국'),
('Kendrick Lamar', 'Kendrick Lamar Duckworth는 미국의 래퍼이자 음악 프로듀서입니다.', 2003, '미국'),
('뉴진스', '뉴진스는 HYBE 산하 레이블 ADOR 소속의 5인조 걸 그룹입니다.', 2022, '대한민국'),
('The Weeknd', 'Abel Makkonen Tesfaye는 캐나다의 싱어송라이터이자 음반 프로듀서입니다.', 2010, '캐나다'),
('AKMU', '악동뮤지션은 YG 엔터테인먼트 소속의 남매 듀오입니다.', 2014, '대한민국');

-- Albums 테이블에 샘플 데이터 추가
INSERT INTO Albums (album_title, artist_id, release_date, genre, album_cover_url) VALUES
('Map of the Soul: 7', 1, '2020-02-21', 'K-Pop', 'https://example.com/bts_mots7.jpg'),
('Love Yourself: Tear', 1, '2018-05-18', 'K-Pop', 'https://example.com/bts_tear.jpg'),
('Lilac', 2, '2021-03-25', 'K-Pop', 'https://example.com/iu_lilac.jpg'),
('Modern Times', 2, '2013-10-07', 'K-Pop', 'https://example.com/iu_moderntimes.jpg'),
('25', 3, '2015-11-20', 'Pop', 'https://example.com/adele_25.jpg'),
('21', 3, '2011-01-24', 'Pop', 'https://example.com/adele_21.jpg'),
('24K Magic', 4, '2016-11-18', 'R&B', 'https://example.com/bruno_24k.jpg'),
('THE ALBUM', 5, '2020-10-02', 'K-Pop', 'https://example.com/blackpink_album.jpg'),
('Born Pink', 5, '2022-09-16', 'K-Pop', 'https://example.com/blackpink_bornpink.jpg'),
('Music of the Spheres', 6, '2021-10-15', 'Pop Rock', 'https://example.com/coldplay_spheres.jpg'),
('DAMN.', 7, '2017-04-14', 'Hip Hop', 'https://example.com/kendrick_damn.jpg'),
('OMG', 8, '2023-01-02', 'K-Pop', 'https://example.com/newjeans_omg.jpg'),
('After Hours', 9, '2020-03-20', 'R&B', 'https://example.com/weeknd_afterhours.jpg'),
('Dawn', 10, '2019-11-25', 'K-Pop', 'https://example.com/akmu_dawn.jpg');

-- Songs 테이블에 샘플 데이터 추가
INSERT INTO Songs (song_title, album_id, artist_id, duration, track_number, release_date, genre, play_count) VALUES
('ON', 1, 1, 252, 1, '2020-02-21', 'K-Pop', 8500000),
('Black Swan', 1, 1, 196, 2, '2020-02-21', 'K-Pop', 7200000),
('Fake Love', 2, 1, 243, 1, '2018-05-18', 'K-Pop', 9800000),
('LILAC', 3, 2, 214, 1, '2021-03-25', 'K-Pop', 5400000),
('Celebrity', 3, 2, 197, 2, '2021-03-25', 'K-Pop', 6100000),
('The Red Shoes', 4, 2, 229, 1, '2013-10-07', 'K-Pop', 3200000),
('Hello', 5, 3, 295, 1, '2015-11-20', 'Pop', 12500000),
('When We Were Young', 5, 3, 290, 2, '2015-11-20', 'Pop', 8600000),
('Rolling in the Deep', 6, 3, 228, 1, '2011-01-24', 'Pop', 18700000),
('Someone Like You', 6, 3, 285, 2, '2011-01-24', 'Pop', 19200000),
('24K Magic', 7, 4, 226, 1, '2016-11-18', 'R&B', 16300000),
('Thats What I Like', 7, 4, 206, 2, '2016-11-18', 'R&B', 15700000),
('How You Like That', 8, 5, 182, 1, '2020-10-02', 'K-Pop', 14200000),
('Ice Cream', 8, 5, 175, 2, '2020-10-02', 'K-Pop', 11800000),
('Pink Venom', 9, 5, 186, 1, '2022-09-16', 'K-Pop', 13500000),
('Shut Down', 9, 5, 174, 2, '2022-09-16', 'K-Pop', 12900000),
('My Universe', 10, 6, 228, 1, '2021-10-15', 'Pop Rock', 9400000),
('Higher Power', 10, 6, 212, 2, '2021-10-15', 'Pop Rock', 8100000),
('HUMBLE.', 11, 7, 177, 1, '2017-04-14', 'Hip Hop', 17800000),
('DNA.', 11, 7, 185, 2, '2017-04-14', 'Hip Hop', 12500000),
('Ditto', 12, 8, 185, 1, '2023-01-02', 'K-Pop', 10200000),
('OMG', 12, 8, 199, 2, '2023-01-02', 'K-Pop', 9800000),
('Blinding Lights', 13, 9, 200, 1, '2020-03-20', 'R&B', 20500000),
('Save Your Tears', 13, 9, 215, 2, '2020-03-20', 'R&B', 18300000),
('How can I love the heartbreak', 14, 10, 271, 1, '2019-11-25', 'K-Pop', 7600000),
('Fishing Trip', 14, 10, 240, 2, '2019-11-25', 'K-Pop', 6800000),
('Dynamite', NULL, 1, 199, NULL, '2020-08-21', 'K-Pop', 25000000),
('Butter', NULL, 1, 164, NULL, '2021-05-21', 'K-Pop', 23000000),
('Permission to Dance', NULL, 1, 187, NULL, '2021-07-09', 'K-Pop', 18000000),
('BBIBBI', NULL, 2, 194, NULL, '2018-10-10', 'K-Pop', 8900000);

-- Playlists 테이블에 샘플 데이터 추가
INSERT INTO Playlists (playlist_name, user_id, is_public, description) VALUES
('K-Pop Collection', 1, TRUE, '내가 좋아하는 K-Pop 노래 모음'),
('Chill Vibes', 2, TRUE, '편안한 분위기의 노래 모음'),
('Rock Anthems', 3, TRUE, '클래식 록 명곡 모음'),
('Jazz Essentials', 4, FALSE, '재즈 입문자를 위한 필수 트랙'),
('Indie Discoveries', 5, TRUE, '새롭게 발견한 인디 아티스트들'),
('Classical Morning', 6, FALSE, '아침에 듣기 좋은 클래식 음악'),
('Hip Hop Beats', 7, TRUE, '강력한 비트의 힙합 트랙'),
('Pop Party Mix', 8, TRUE, '파티에 딱 맞는 팝 음악 믹스'),
('EDM Workout', 9, FALSE, '운동할 때 듣기 좋은 EDM'),
('Ballad Collection', 10, TRUE, '감성적인 발라드 모음');

-- PlaylistSongs 테이블에 샘플 데이터 추가
INSERT INTO PlaylistSongs (playlist_id, song_id, position) VALUES
(1, 1, 1), (1, 2, 2), (1, 3, 3), (1, 4, 4), (1, 5, 5),
(2, 6, 1), (2, 7, 2), (2, 12, 3), (2, 19, 4),
(3, 17, 1), (3, 18, 2),
(4, 10, 1), (4, 11, 2),
(5, 25, 1), (5, 26, 2),
(6, 7, 1), (6, 9, 2),
(7, 19, 1), (7, 20, 2),
(8, 8, 1), (8, 12, 2), (8, 13, 3), (8, 21, 4),
(9, 17, 1), (9, 23, 2), (9, 24, 3),
(10, 9, 1), (10, 10, 2), (10, 25, 3);

-- Likes 테이블에 샘플 데이터 추가
INSERT INTO Likes (user_id, content_type, content_id) VALUES
(1, 'song', 1), (1, 'song', 3), (1, 'album', 1), (1, 'artist', 1),
(2, 'song', 4), (2, 'song', 5), (2, 'album', 3), (2, 'artist', 2),
(3, 'song', 17), (3, 'song', 18), (3, 'album', 10), (3, 'artist', 6),
(4, 'song', 10), (4, 'song', 11), (4, 'album', 6), (4, 'artist', 3),
(5, 'song', 25), (5, 'song', 26), (5, 'album', 14), (5, 'artist', 10),
(6, 'song', 7), (6, 'song', 9), (6, 'album', 5), (6, 'artist', 3),
(7, 'song', 19), (7, 'song', 20), (7, 'album', 11), (7, 'artist', 7),
(8, 'song', 12), (8, 'song', 13), (8, 'album', 7), (8, 'artist', 4),
(9, 'song', 23), (9, 'song', 24), (9, 'album', 13), (9, 'artist', 9),
(10, 'song', 9), (10, 'song', 10), (10, 'album', 6), (10, 'artist', 3);

-- UserSubscriptions 테이블에 샘플 데이터 추가
INSERT INTO UserSubscriptions (user_id, subscription_type, start_date, end_date, payment_method, auto_renewal) VALUES
(1, 'Premium', '2023-01-15', '2024-01-15', 'Credit Card', TRUE),
(2, 'Family', '2023-02-10', '2024-02-10', 'PayPal', TRUE),
(3, 'Free', '2023-03-05', NULL, NULL, FALSE),
(4, 'Premium', '2023-01-20', '2024-01-20', 'Credit Card', TRUE),
(5, 'Student', '2023-04-12', '2023-10-12', 'Credit Card', TRUE),
(6, 'Premium', '2023-02-28', '2024-02-28', 'Credit Card', TRUE),
(7, 'Family', '2023-03-15', '2024-03-15', 'PayPal', TRUE),
(8, 'Free', '2023-05-01', NULL, NULL, FALSE),
(9, 'Premium', '2023-01-10', '2024-01-10', 'Credit Card', TRUE),
(10, 'Student', '2023-06-20', '2023-12-20', 'PayPal', TRUE);
