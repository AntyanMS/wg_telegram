#!/bin/bash

# Путь к вашему скрипту
SCRIPT_PATH="$(pwd)/main.py"

# Имя аккаунта и группы
USER=$(whoami)
GROUP=$(id -gn)

# Путь к вашему скрипту
SCRIPT_PATH="$(pwd)/main.py"

# Функция для старта процесса
start_process() {
    nohup python3 "$SCRIPT_PATH" > /dev/null 2>&1 &
    echo $!
}

# Проверка состояния процесса
check_process() {
    ps aux | grep "[p]ython main.py" | awk '{print $2}'
}

# Основной цикл
while true; do
    PID=$(check_process)

    if [ -z "$PID" ]; then
        echo "Процесс не найден. Запуск..."
        PID=$(start_process)
        echo "Запущен процесс с PID: $PID"
    else
        # Проверка, если процесс не отвечает
        if ! kill -0 "$PID" 2>/dev/null; then
            echo "Процесс упал. Перезапуск..."
            kill -9 "$PID" 2>/dev/null
            PID=$(start_process)
            echo "Запущен процесс с PID: $PID"
        fi
    fi

    sleep 10  # Интервал проверки
done
