CREATE TABLE IF NOT EXISTS evade_system (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    evade_active BOOLEAN DEFAULT FALSE,
    evade_end_time INT,
    evade_cooldown_end_time INT,
    FOREIGN KEY (player_id) REFERENCES users(identifier)
);