#!/bin/bash

# ==============================================================================
# Script Name:  fix_mariadb.sh
# Description:  Відновлення роботи MariaDB при відсутності директорій та даних.
# Why?          У реальних проєктах бази даних можуть виходити з ладу через 
#               помилки монтування дисків або некоректні оновлення. Розуміння 
#               процесу ініціалізації БД є критичним для DevOps.
# ==============================================================================

# Перевірка на права root
if [[ $EUID -ne 0 ]]; then
   echo "Помилка: Цей скрипт потрібно запускати від root (sudo)."
   exit 1
fi

DB_DIR="/var/lib/mysql"

echo "--- Діагностика системи ---"
systemctl status mariadb --no-pager

echo -e "\n--- Виправлення MariaDB ---"

# Крок 1: Створення відсутньої директорії (якщо вона була видалена)
if [ ! -d "$DB_DIR" ]; then
    echo "Створюю директорію бази даних: $DB_DIR"
    mkdir -p "$DB_DIR"
    chown -R mysql:mysql "$DB_DIR"
fi

# Крок 2: Ініціалізація бази даних (якщо вона пуста)
if [ -z "$(ls -A $DB_DIR)" ]; then
    echo "Ініціалізую базу даних MariaDB..."
    mysql_install_db --user=mysql --basedir=/usr --datadir="$DB_DIR"
fi

# Крок 3: Запуск сервісу
echo "Запускаю службу mariadb..."
systemctl start mariadb

# Перевірка результату
if systemctl is-active --quiet mariadb; then
    echo "УСПІХ: Служба MariaDB працює!"
else
    echo "ПОМИЛКА: Не вдалося запустити MariaDB. Перевірте journalctl -xe."
    exit 1
fi
