$ExecutingTestPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Path

BeforeAll {
    Import-Module -Name $(Join-Path -Path $ExecutingTestPath -ChildPath '..\..\..\..\PowerShell\ScubaGear\Modules\Utils\ScubaConfig.psm1')
}


Describe -tag "Utils" -name 'ScubaConfig' {
    Context 'General case'{
        It 'Good folder name'{
            { Get-ScubaConfig -Path '.'} |
                Should -Throw -ExpectedMessage "Cannot validate argument on parameter 'Path'. SCuBA configuration Path argument must be a file."
        }
        It 'Bad file name throws exception' {
            { Get-ScubaConfig -Path "Bad file name" } |
                Should -Throw -ExpectedMessage "Cannot validate argument on parameter 'Path'. SCuBA configuration file or folder does not exist."
        }
    }
    context 'JSON Configuration' {
        BeforeAll {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', 'ScubaConfigTestFile')]
            $ScubaConfigTestFile = Join-Path -Path $PSScriptRoot -ChildPath config_test.json
        }
        It 'Valid config file'{
            Remove-ScubaConfig
            { Get-ScubaConfig -Path $ScubaConfigTestFile } |
                Should -Not -Throw
        }
        It 'Valid string parameter'{
            Remove-ScubaConfig
            Get-ScubaConfig -Path $ScubaConfigTestFile
            $ScubaConfig.M365Environment | Should -Be 'commercial'
        }
        It 'Valid array parameter'{
            Remove-ScubaConfig
            Get-ScubaConfig -Path $ScubaConfigTestFile
            $ScubaConfig.ProductNames | Should -Contain 'aad'
        }
        It 'Valid boolean parameter'{
            Remove-ScubaConfig
            Get-ScubaConfig -Path $ScubaConfigTestFile
            $ScubaConfig.DisconnectOnExit | Should -Be $false
        }
        It 'Valid object parameter'{
            Remove-ScubaConfig
            Get-ScubaConfig -Path $ScubaConfigTestFile
            $ScubaConfig.AnObject.name | Should -Be 'MyObjectName'
        }
    }
    context 'YAML Configuration' {
        BeforeAll {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', 'ScubaConfigTestFile')]
            $ScubaConfigTestFile = Join-Path -Path $PSScriptRoot -ChildPath config_test.yaml
        }
        It 'Valid config file'{
            Remove-ScubaConfig
            { Get-ScubaConfig -Path $ScubaConfigTestFile -Format 'yaml'} |
                Should -Not -Throw
        }
        It 'Valid string parameter'{
            Remove-ScubaConfig
            Get-ScubaConfig -Path $ScubaConfigTestFile -Format 'yaml'
            $ScubaConfig.M365Environment | Should -Be 'commercial'
        }
        It 'Valid array parameter'{
            Remove-ScubaConfig
            Get-ScubaConfig -Path $ScubaConfigTestFile -Format 'yaml'
            $ScubaConfig.ProductNames | Should -Contain 'aad'
        }
        It 'Valid boolean parameter'{
            Remove-ScubaConfig
            Get-ScubaConfig -Path $ScubaConfigTestFile -Format 'yaml'
            $ScubaConfig.DisconnectOnExit | Should -Be $false
        }
        It 'Valid object parameter'{
            Remove-ScubaConfig
            Get-ScubaConfig -Path $ScubaConfigTestFile -Format 'yaml'
            $ScubaConfig.AnObject.name | Should -Be 'MyObjectName'
        }
    }
}