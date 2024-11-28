# Задайте IP-адрес DHCP сервера
$dhcpServer = "192.168.0.1"

# Путь для сохранения выходного файла
$outputFile = "E:\scripts"

$dhcpScopes = Get-DhcpServerv4Scope -ComputerName $dhcpServer

# Создание пустого файла для записи
New-Item -Path $outputFile -ItemType File -Force

foreach ($scope in $dhcpScopes) {
    Write-Host "Получаем IP-адреса для области: $($scope.Name)"
    
    # Получение всех активных арендуемых IP-адресов в области
    $leases = Get-DhcpServerv4Lease -ComputerName $dhcpServer -ScopeId $scope.ScopeId

    # Запись арендуемых IP 
    foreach ($lease in $leases) {
        $ip = $lease.IPAddress
        $mac = $lease.ClientId
        $hostname = $lease.HostName
        $line = "$ip, $mac, $hostname, $scope.Name"
        
        Add-Content -Path $outputFile -Value $line
    }
}

Write-Host "Генерация файла завершена Список IP-адресов в $outputFile"
