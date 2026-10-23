
<?php

$host = '127.0.0.1';
$banco = 'agenda';
$usuario = 'agenda_app';
$senha = getenv('DB_PASSWORD');

if ($senha === false || $senha === '') {
    die('Erro: a variável DB_PASSWORD não foi configurada.');
}

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

try {
    $conexao = new mysqli($host, $usuario, $senha, $banco);
    $conexao->set_charset('utf8mb4');
} catch (mysqli_sql_exception $e) {
    error_log('Erro ao conectar ao banco: ' . $e->getMessage());
    die('Não foi possível conectar ao banco de dados.');
}
