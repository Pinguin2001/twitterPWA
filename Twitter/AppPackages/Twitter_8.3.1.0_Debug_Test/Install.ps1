﻿#
# This script just calls the Add-AppDevPackage.ps1 script that lives next to it.
#

param(
    [switch]$Force = $false,
    [switch]$SkipLoggingTelemetry = $false
)

$scriptArgs = ""
if ($Force)
{
    $scriptArgs = '-Force'
}

if ($SkipLoggingTelemetry)
{
    if ($Force)
    {
        $scriptArgs += ' '
    }

    $scriptArgs += '-SkipLoggingTelemetry'
}

try
{
    # Log telemetry data regarding the use of the script if possible.
    # There are three ways that this can be disabled:
    #   1. If the "TelemetryDependencies" folder isn't present.  This can be excluded at build time by setting the MSBuild property AppxLogTelemetryFromSideloadingScript to false
    #   2. If the SkipLoggingTelemetry switch is passed to this script.
    #   3. If Visual Studio telemetry is disabled via the registry.
    $TelemetryAssembliesFolder = (Join-Path $PSScriptRoot "TelemetryDependencies")
    if (!$SkipLoggingTelemetry -And (Test-Path $TelemetryAssembliesFolder))
    {
        $job = Start-Job -FilePath (Join-Path $TelemetryAssembliesFolder "LogSideloadingTelemetry.ps1") -ArgumentList $TelemetryAssembliesFolder, "VS/DesignTools/SideLoadingScript/Install", $null, $null
        Wait-Job -Job $job -Timeout 60 | Out-Null
    }
}
catch
{
    # Ignore telemetry errors
}

$currLocation = Get-Location
Set-Location $PSScriptRoot
Invoke-Expression ".\Add-AppDevPackage.ps1 $scriptArgs"
Set-Location $currLocation
# SIG # Begin signature block
# MIIlkwYJKoZIhvcNAQcCoIIlhDCCJYACAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCC7kxV/l3biwCGH
# VuAKUAkPVeCZ2LSQIMJf+ROzV3B37KCCC3YwggT+MIID5qADAgECAhMzAAAEkWRi
# 87c+4gzNAAAAAASRMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTAwHhcNMjIwNTEyMjA0NzA2WhcNMjMwNTExMjA0NzA2WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQCeFj/vKCjxbgwSU1ldPQ6k6uXGdB9/XOxPPKyJi//8BSt+6aRtTLpSW1PKg9La
# ebFykpmrmd28L2mH0kT0EftnUU5iFAuZ981vaSFWpdHaI1xzP4JC6nWY5ogEf+/i
# fpNkoHE2eCrgctmUBy59Wi+9zWdHqmiV4WBUr4+xyYe7rp9lGSkGtYSFJTSgJrDx
# ni+MJO2Gc6CQGkhBa//0Dd2/iJtpEkuFUhjJjc+PtjAn25LtyAwOflZsj1R+0jkq
# v6rqepKLtkt8DSv7AcwS/wgOF2CAoAY+VuQrQxUw4CFpsS8rSX1q1Hu5EIRzmJtq
# fAF0P0Do/T8IM2jH33pgaHOLAgMBAAGjggF9MIIBeTAfBgNVHSUEGDAWBgorBgEE
# AYI3PQYBBggrBgEFBQcDAzAdBgNVHQ4EFgQUyFrUDAXsuN6gMqKAk8zL9o06Wi8w
# VAYDVR0RBE0wS6RJMEcxLTArBgNVBAsTJE1pY3Jvc29mdCBJcmVsYW5kIE9wZXJh
# dGlvbnMgTGltaXRlZDEWMBQGA1UEBRMNMjMwODY1KzQ3MDU2MzAfBgNVHSMEGDAW
# gBTm/F97uyIAWORyTrX0IXQjMubvrDBWBgNVHR8ETzBNMEugSaBHhkVodHRwOi8v
# Y3JsLm1pY3Jvc29mdC5jb20vcGtpL2NybC9wcm9kdWN0cy9NaWNDb2RTaWdQQ0Ff
# MjAxMC0wNy0wNi5jcmwwWgYIKwYBBQUHAQEETjBMMEoGCCsGAQUFBzAChj5odHRw
# Oi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY0NvZFNpZ1BDQV8yMDEw
# LTA3LTA2LmNydDAMBgNVHRMBAf8EAjAAMA0GCSqGSIb3DQEBCwUAA4IBAQASy8N+
# 5LSmLRbxkleTFKJVhAPjgokqEmQDZDq+UlfUBLpXgZwimuJVSyAaY8C64kA7w0yI
# i5jICvPBKeWxG2vNI27uxLPdzhI7xPSHGRIHAnXDqj1XwGEEfR4gOUXZ7e8Ife4v
# j1NRd2jRo2Gi50bRbj/FtXVFQS0p/lHI1YIlg8k512iTS2v479AnF4NUtiKQ/JYt
# 1iLcnj9yqkGK9MYa0lIOgGbcw4PJwC8VZj+pmAnCmKXfxzCNuEFfFcES+AseGUSw
# CdJzj//4oNDLbcpSMSV/RV4eaOprs3vk+kR5MLEYrD3zMOdDrDWDSClrpzlVhhp2
# UcJd/JgYnxLdUjwEMIIGcDCCBFigAwIBAgIKYQxSTAAAAAAAAzANBgkqhkiG9w0B
# AQsFADCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNV
# BAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEyMDAG
# A1UEAxMpTWljcm9zb2Z0IFJvb3QgQ2VydGlmaWNhdGUgQXV0aG9yaXR5IDIwMTAw
# HhcNMTAwNzA2MjA0MDE3WhcNMjUwNzA2MjA1MDE3WjB+MQswCQYDVQQGEwJVUzET
# MBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMV
# TWljcm9zb2Z0IENvcnBvcmF0aW9uMSgwJgYDVQQDEx9NaWNyb3NvZnQgQ29kZSBT
# aWduaW5nIFBDQSAyMDEwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
# 6Q5kUHlntcTj/QkATJ6UrPdWaOpE2M/FWE+ppXZ8bUW60zmStKQe+fllguQX0o/9
# RJwI6GWTzixVhL99COMuK6hBKxi3oktuSUxrFQfe0dLCiR5xlM21f0u0rwjYzIjW
# axeUOpPOJj/s5v40mFfVHV1J9rIqLtWFu1k/+JC0K4N0yiuzO0bj8EZJwRdmVMkc
# vR3EVWJXcvhnuSUgNN5dpqWVXqsogM3Vsp7lA7Vj07IUyMHIiiYKWX8H7P8O7YAS
# NUwSpr5SW/Wm2uCLC0h31oVH1RC5xuiq7otqLQVcYMa0KlucIxxfReMaFB5vN8sZ
# M4BqiU2jamZjeJPVMM+VHwIDAQABo4IB4zCCAd8wEAYJKwYBBAGCNxUBBAMCAQAw
# HQYDVR0OBBYEFOb8X3u7IgBY5HJOtfQhdCMy5u+sMBkGCSsGAQQBgjcUAgQMHgoA
# UwB1AGIAQwBBMAsGA1UdDwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQY
# MBaAFNX2VsuP6KJcYmjRPZSQW9fOmhjEMFYGA1UdHwRPME0wS6BJoEeGRWh0dHA6
# Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY1Jvb0NlckF1
# dF8yMDEwLTA2LTIzLmNybDBaBggrBgEFBQcBAQROMEwwSgYIKwYBBQUHMAKGPmh0
# dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2kvY2VydHMvTWljUm9vQ2VyQXV0XzIw
# MTAtMDYtMjMuY3J0MIGdBgNVHSAEgZUwgZIwgY8GCSsGAQQBgjcuAzCBgTA9Bggr
# BgEFBQcCARYxaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL1BLSS9kb2NzL0NQUy9k
# ZWZhdWx0Lmh0bTBABggrBgEFBQcCAjA0HjIgHQBMAGUAZwBhAGwAXwBQAG8AbABp
# AGMAeQBfAFMAdABhAHQAZQBtAGUAbgB0AC4gHTANBgkqhkiG9w0BAQsFAAOCAgEA
# GnTvV08pe8QWhXi4UNMi/AmdrIKX+DT/KiyXlRLl5L/Pv5PI4zSp24G43B4AvtI1
# b6/lf3mVd+UC1PHr2M1OHhthosJaIxrwjKhiUUVnCOM/PB6T+DCFF8g5QKbXDrMh
# KeWloWmMIpPMdJjnoUdD8lOswA8waX/+0iUgbW9h098H1dlyACxphnY9UdumOUjJ
# N2FtB91TGcun1mHCv+KDqw/ga5uV1n0oUbCJSlGkmmzItx9KGg5pqdfcwX7RSXCq
# tq27ckdjF/qm1qKmhuyoEESbY7ayaYkGx0aGehg/6MUdIdV7+QIjLcVBy78dTMgW
# 77Gcf/wiS0mKbhXjpn92W9FTeZGFndXS2z1zNfM8rlSyUkdqwKoTldKOEdqZZ14y
# jPs3hdHcdYWch8ZaV4XCv90Nj4ybLeu07s8n07VeafqkFgQBpyRnc89NT7beBVaX
# evfpUk30dwVPhcbYC/GO7UIJ0Q124yNWeCImNr7KsYxuqh3khdpHM2KPpMmRM19x
# HkCvmGXJIuhCISWKHC1g2TeJQYkqFg/XYTyUaGBS79ZHmaCAQO4VgXc+nOBTGBpQ
# HTiVmx5mMxMnORd4hzbOTsNfsvU9R1O24OXbC2E9KteSLM43Wj5AQjGkHxAIwlac
# vyRdUQKdannSF9PawZSOB3slcUSrBmrm1MbfI5qWdcUxghlzMIIZbwIBATCBlTB+
# MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVk
# bW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSgwJgYDVQQDEx9N
# aWNyb3NvZnQgQ29kZSBTaWduaW5nIFBDQSAyMDEwAhMzAAAEkWRi87c+4gzNAAAA
# AASRMA0GCWCGSAFlAwQCAQUAoIGuMBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3AgEE
# MBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMC8GCSqGSIb3DQEJBDEiBCC5
# 5sfwy7JnuBF0jRtZGRnrFzHJ1nC8iR8tv9OzWMo65TBCBgorBgEEAYI3AgEMMTQw
# MqAUgBIATQBpAGMAcgBvAHMAbwBmAHShGoAYaHR0cDovL3d3dy5taWNyb3NvZnQu
# Y29tMA0GCSqGSIb3DQEBAQUABIIBAE2GN+6Ob2xmP6lMMbzzxSj5pn2nV1bEswtl
# j/ewtHZ31gYf3Npe+ilJNWeItPE4gZhGuJ92/64qpLywlK98U/ljg/X78y2TQKHs
# u6qfzthL1lHCZ5Ofjt7kPCgm4KkD4GGDnT49VDo79f6pAmdS35taMZp9VtNOIV0F
# a/sEMjDDVXCxBlF/IrermzXUEmeXvcsgJk8eOmp5g2pbo5WFG7uKwGTwVjhkSxer
# WLQ79Y0v63NWI4tE4w9wfS22kACllfb7sZjkxgmSgFPoZBZWYhsrFg84oh2HMSuk
# nc2KIQV109vpKtfx5BAoBKGJkhqdrF1oxKH2QiesvJEMcVo+X3Chghb9MIIW+QYK
# KwYBBAGCNwMDATGCFukwghblBgkqhkiG9w0BBwKgghbWMIIW0gIBAzEPMA0GCWCG
# SAFlAwQCAQUAMIIBUQYLKoZIhvcNAQkQAQSgggFABIIBPDCCATgCAQEGCisGAQQB
# hFkKAwEwMTANBglghkgBZQMEAgEFAAQgw4lrTrjjL4g0QQ8AgAN6/UcAQdEcfVXQ
# wuyhETRO+wACBmPuFn1lfhgTMjAyMzAzMDMwMDI4MTguMTQ1WjAEgAIB9KCB0KSB
# zTCByjELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcT
# B1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjElMCMGA1UE
# CxMcTWljcm9zb2Z0IEFtZXJpY2EgT3BlcmF0aW9uczEmMCQGA1UECxMdVGhhbGVz
# IFRTUyBFU046REQ4Qy1FMzM3LTJGQUUxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1l
# LVN0YW1wIFNlcnZpY2WgghFUMIIHDDCCBPSgAwIBAgITMwAAAcUDzc0hofTvOQAB
# AAABxTANBgkqhkiG9w0BAQsFADB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
# aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
# cnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAx
# MDAeFw0yMjExMDQxOTAxMzJaFw0yNDAyMDIxOTAxMzJaMIHKMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1l
# cmljYSBPcGVyYXRpb25zMSYwJAYDVQQLEx1UaGFsZXMgVFNTIEVTTjpERDhDLUUz
# MzctMkZBRTElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2VydmljZTCC
# AiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAKtIXbO9Hl9tye6WqaWil0Yc
# /k0+ySdzr1X9/jfHzacUbOY2OIRL9wVf8ORFl22XTuJt8Y9NZUyP8Q5KvsrY7oj3
# vMRl7GcQ57b+y9RMzHeYyEqifnmLvJIFdOepqrPHQaOecWTzz3MX+btfc59OGjEB
# eT11fwuGS0oxWvSBTXK4m3Tpt5Rlta0ERWto1LLqeoL+t+KuVMB9PVhhrtM/PUW7
# W8jOeb5gYFlfHnem2Qma3KGCIzC/BUU7xpc56puh7cGXVzMCh092v5C1Ej4hgLKy
# IBM8+zaQaXjrILPU68Mlk2QTWwcMiAApkN+I/rkeHrdoWZPjR+PSoRCcmA9vnTiG
# gxgdhFDRUmHMtTJILWbdXkagQdJvmD2M+x46HD8pCmDUGe07/s4JTn3womsdYzm9
# LuiGAuV9Sa/AME3LGg8rt6gIcfHBUDfQw4IlWcPlERWfKMqA5OrCFdZ8ec2S8voT
# bWpHj1/Uu2PJ9alnwI6FzxOitP3W08POxDiS/wZSRnCqBU8ra9Mz4PzDSUm+n9mv
# 8A5F6BghliYkKxk8Yzj/kfev5yCBtOXhNS6ZMthTnWDDweA4Vu7QXWWrrXqU07ko
# ZoJ/hihEfAKANYEkpNRAuWV+HKaVZ4CaW5TAbvK/7QoXx1XV74mOoQ0oR8EApmam
# Xm4EmB5x5eLqxPuCumQvAgMBAAGjggE2MIIBMjAdBgNVHQ4EFgQUVOq7OL9ZsTWB
# v67aS8K1cHpNBWswHwYDVR0jBBgwFoAUn6cVXQBeYl2D9OXSZacbUzUZ6XIwXwYD
# VR0fBFgwVjBUoFKgUIZOaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9j
# cmwvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUyMDIwMTAoMSkuY3JsMGwG
# CCsGAQUFBwEBBGAwXjBcBggrBgEFBQcwAoZQaHR0cDovL3d3dy5taWNyb3NvZnQu
# Y29tL3BraW9wcy9jZXJ0cy9NaWNyb3NvZnQlMjBUaW1lLVN0YW1wJTIwUENBJTIw
# MjAxMCgxKS5jcnQwDAYDVR0TAQH/BAIwADATBgNVHSUEDDAKBggrBgEFBQcDCDAN
# BgkqhkiG9w0BAQsFAAOCAgEAjKjefH6zBzknHIivgnZ6+nSvH07IEA3mfW70Iwrs
# TSCWSfdvsaXikQn916uO6nUcpJClJ2QunR4S8LdX4cMosvy33VUPcn9YWGf0aU0v
# s9IZ2qCvj/yAwIlDZt9jVy4QwbtD+Em/7gleIzrjVHJiYaaQUIEFYRcf+eyWJNSw
# nYyHnv/xq3H25ELYmKG/Tmvdw0o27A9Y6monBJ5HJVDf5hJvWbJwpwNfvzkA6f/E
# OHD3x/eCzOCel9DbTQXlcsL1h9MLjGjicx4AywniVJBRPRxPLAQ1XnZo+szyQCPu
# 6My42KsO4uERW4krX1mUho8LfpSyUGUVlAnE92h2L06NWFg2bJKIVoO+8PXxdkG4
# jvQ356qGe0KMx4u0Yj6W44JCTAIa4aXk3/2rdnvfh2JCjm1JoDwKx9Vo4r8JtXez
# 2FrGqy+7uambpN+hm9ZhE0taANl19/gt64Lc0aIT/PamVX+/ZVb45oN+DbSAiv6T
# JPfUgbrYIbYqRUjEHW11J0tqHi7fXCrr9TCbvoCfN6l0zZENkKocbTUb2xPUKpqi
# UMOVVv+Emc3taT18cjkzucg6vokSFLm6nkM5lHApIsjbgix1ofDiwiOZiDgtYi7V
# Q39pcPXlq6KcLuUgybU/2cKiFNam9lPjY5DXI9YWzgwURC2k01nfdUSYlCPZ3CZB
# oP4wggdxMIIFWaADAgECAhMzAAAAFcXna54Cm0mZAAAAAAAVMA0GCSqGSIb3DQEB
# CwUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UE
# BxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMTIwMAYD
# VQQDEylNaWNyb3NvZnQgUm9vdCBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkgMjAxMDAe
# Fw0yMTA5MzAxODIyMjVaFw0zMDA5MzAxODMyMjVaMHwxCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0
# YW1wIFBDQSAyMDEwMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA5OGm
# TOe0ciELeaLL1yR5vQ7VgtP97pwHB9KpbE51yMo1V/YBf2xK4OK9uT4XYDP/XE/H
# ZveVU3Fa4n5KWv64NmeFRiMMtY0Tz3cywBAY6GB9alKDRLemjkZrBxTzxXb1hlDc
# wUTIcVxRMTegCjhuje3XD9gmU3w5YQJ6xKr9cmmvHaus9ja+NSZk2pg7uhp7M62A
# W36MEBydUv626GIl3GoPz130/o5Tz9bshVZN7928jaTjkY+yOSxRnOlwaQ3KNi1w
# jjHINSi947SHJMPgyY9+tVSP3PoFVZhtaDuaRr3tpK56KTesy+uDRedGbsoy1cCG
# MFxPLOJiss254o2I5JasAUq7vnGpF1tnYN74kpEeHT39IM9zfUGaRnXNxF803RKJ
# 1v2lIH1+/NmeRd+2ci/bfV+AutuqfjbsNkz2K26oElHovwUDo9Fzpk03dJQcNIIP
# 8BDyt0cY7afomXw/TNuvXsLz1dhzPUNOwTM5TI4CvEJoLhDqhFFG4tG9ahhaYQFz
# ymeiXtcodgLiMxhy16cg8ML6EgrXY28MyTZki1ugpoMhXV8wdJGUlNi5UPkLiWHz
# NgY1GIRH29wb0f2y1BzFa/ZcUlFdEtsluq9QBXpsxREdcu+N+VLEhReTwDwV2xo3
# xwgVGD94q0W29R6HXtqPnhZyacaue7e3PmriLq0CAwEAAaOCAd0wggHZMBIGCSsG
# AQQBgjcVAQQFAgMBAAEwIwYJKwYBBAGCNxUCBBYEFCqnUv5kxJq+gpE8RjUpzxD/
# LwTuMB0GA1UdDgQWBBSfpxVdAF5iXYP05dJlpxtTNRnpcjBcBgNVHSAEVTBTMFEG
# DCsGAQQBgjdMg30BATBBMD8GCCsGAQUFBwIBFjNodHRwOi8vd3d3Lm1pY3Jvc29m
# dC5jb20vcGtpb3BzL0RvY3MvUmVwb3NpdG9yeS5odG0wEwYDVR0lBAwwCgYIKwYB
# BQUHAwgwGQYJKwYBBAGCNxQCBAweCgBTAHUAYgBDAEEwCwYDVR0PBAQDAgGGMA8G
# A1UdEwEB/wQFMAMBAf8wHwYDVR0jBBgwFoAU1fZWy4/oolxiaNE9lJBb186aGMQw
# VgYDVR0fBE8wTTBLoEmgR4ZFaHR0cDovL2NybC5taWNyb3NvZnQuY29tL3BraS9j
# cmwvcHJvZHVjdHMvTWljUm9vQ2VyQXV0XzIwMTAtMDYtMjMuY3JsMFoGCCsGAQUF
# BwEBBE4wTDBKBggrBgEFBQcwAoY+aHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3Br
# aS9jZXJ0cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0yMy5jcnQwDQYJKoZIhvcNAQEL
# BQADggIBAJ1VffwqreEsH2cBMSRb4Z5yS/ypb+pcFLY+TkdkeLEGk5c9MTO1OdfC
# cTY/2mRsfNB1OW27DzHkwo/7bNGhlBgi7ulmZzpTTd2YurYeeNg2LpypglYAA7AF
# vonoaeC6Ce5732pvvinLbtg/SHUB2RjebYIM9W0jVOR4U3UkV7ndn/OOPcbzaN9l
# 9qRWqveVtihVJ9AkvUCgvxm2EhIRXT0n4ECWOKz3+SmJw7wXsFSFQrP8DJ6LGYnn
# 8AtqgcKBGUIZUnWKNsIdw2FzLixre24/LAl4FOmRsqlb30mjdAy87JGA0j3mSj5m
# O0+7hvoyGtmW9I/2kQH2zsZ0/fZMcm8Qq3UwxTSwethQ/gpY3UA8x1RtnWN0SCyx
# TkctwRQEcb9k+SS+c23Kjgm9swFXSVRk2XPXfx5bRAGOWhmRaw2fpCjcZxkoJLo4
# S5pu+yFUa2pFEUep8beuyOiJXk+d0tBMdrVXVAmxaQFEfnyhYWxz/gq77EFmPWn9
# y8FBSX5+k77L+DvktxW/tM4+pTFRhLy/AsGConsXHRWJjXD+57XQKBqJC4822rpM
# +Zv/Cuk0+CQ1ZyvgDbjmjJnW4SLq8CdCPSWU5nR0W2rRnj7tfqAxM328y+l7vzhw
# RNGQ8cirOoo6CGJ/2XBjU02N7oJtpQUQwXEGahC0HVUzWLOhcGbyoYICyzCCAjQC
# AQEwgfihgdCkgc0wgcoxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9u
# MRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRp
# b24xJTAjBgNVBAsTHE1pY3Jvc29mdCBBbWVyaWNhIE9wZXJhdGlvbnMxJjAkBgNV
# BAsTHVRoYWxlcyBUU1MgRVNOOkREOEMtRTMzNy0yRkFFMSUwIwYDVQQDExxNaWNy
# b3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNloiMKAQEwBwYFKw4DAhoDFQAhABr2F2SS
# u3FKOtvi7xGEBMe/56CBgzCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpX
# YXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQg
# Q29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAy
# MDEwMA0GCSqGSIb3DQEBBQUAAgUA56uxLzAiGA8yMDIzMDMwMzA3MzUxMVoYDzIw
# MjMwMzA0MDczNTExWjB0MDoGCisGAQQBhFkKBAExLDAqMAoCBQDnq7EvAgEAMAcC
# AQACAhSqMAcCAQACAhQRMAoCBQDnrQKvAgEAMDYGCisGAQQBhFkKBAIxKDAmMAwG
# CisGAQQBhFkKAwKgCjAIAgEAAgMHoSChCjAIAgEAAgMBhqAwDQYJKoZIhvcNAQEF
# BQADgYEAvcOPMFjo8IpA//lKkVli0q1+iLY0xV+Nl46fnwVNHQng5MgnIwYI6l6r
# pFIa9pJpOvSJhEpIakrGiz+6Vx76MQfDmlcyBNQhnMnsnwDDgNUo5MNff6d3HTX8
# ClayETHNXnWSpwEdOXRx15T7WTw0Z/AdAbTqrHci32NZAcw2J9YxggQNMIIECQIB
# ATCBkzB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UE
# BxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYD
# VQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAAcUDzc0hofTv
# OQABAAABxTANBglghkgBZQMEAgEFAKCCAUowGgYJKoZIhvcNAQkDMQ0GCyqGSIb3
# DQEJEAEEMC8GCSqGSIb3DQEJBDEiBCAsjGZBWq5St45oOX+wlsCK51vAFgIfmegh
# 5bKOefWX/TCB+gYLKoZIhvcNAQkQAi8xgeowgecwgeQwgb0EIBkBsZH2JHdMCvld
# PcDtLDvrJvIADMo+RLij6rzUP3yxMIGYMIGApH4wfDELMAkGA1UEBhMCVVMxEzAR
# BgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1p
# Y3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3Rh
# bXAgUENBIDIwMTACEzMAAAHFA83NIaH07zkAAQAAAcUwIgQgWMwNcDJ5M+k/pTiZ
# +gLRfkFPurn91wSotOWcc79UZpcwDQYJKoZIhvcNAQELBQAEggIApSjy7mEwn2gf
# gFYsEfFSWIY9r0S8S8FvYX8kluj4qwOwBpX/Ul/JoxkGUA4IfTyddzi5Vh6ayumI
# 5GjO2e20Ey/keubY9S2WWrmHUtUZQgBUL+2SZXrBBXJS+Qo49m2aLdmpteAuLdnM
# MPb8vinGtvqyE0q9YeHR/Xf5KFkt8FJcaIINoV4NzMfESIxpEJxWbqUUlHm5aK7v
# deYNLwXiYw8ZrtKcmFP3nU1xGJ6ZhjpD2V4SSdnWH0vIOe/0PtACukOCWH12rnyA
# 7OL1rzc7R4T9PEX/qWAl1ZcJKRo/6AwUHSnZX3NzdWJUHbsAyy4y1Pg1vRqfI5YW
# U+lw7UlBWHB2idfpo8qFnbGD3tVYFk3U8ZM6E7ZmK1t15RoWp6wXPiL+PAyNYmwN
# zBBoYpulX7KOZrLvjTXJ+ldCZeHclvNikxapVAIqkz/eGEAvHF5O6mdB+odQgLDY
# 1eXcRDhuMfUdopDSRnU4CXb32La/GQ9NspIuhsViSAyHtExCknOBzluLzwQZTmiT
# /WT4Tj56A7O3cw7F2wgjSPZofgyHsapZ96Q8j7t426GuvvG1CXcE90SkNtZMAnyO
# wOBrV9JbPuP4j2C8raJoOqOdBQgB05/dqe5ZZGVJVS0nG068bV/GZGOoEuCB5HcQ
# Khft7LNKJVULDh7NF9ZMf8HiQjTN4Cw=
# SIG # End signature block