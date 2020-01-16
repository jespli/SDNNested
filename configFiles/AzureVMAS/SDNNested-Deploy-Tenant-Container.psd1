@{
    ScriptVersion        = "2.0"

    VHDPath              = "Z:"
    VHDFile              = "Win2019-Core.vhdx"
    VMLocation           = "C:\VMs"
    
    ProductKey           = 'T99NG-BPP9T-2FX7V-TX9DP-8XFB4'

    VMMemory             = 2GB
    VMProcessorCount     = 2
    SwitchName           = "SDNSwitch"

    HYPV                 = @("SDN-HOST01.SDN.LAB", "SDN-HOST02.SDN.LAB")

    DomainJoinUserName   = "SDN\administrator"
    LocalAdminDomainUser = "SDN\administrator"

    Tenants              = 
    @(
        @{
            Name                              = "Contoso";
            TenantVirtualNetworkName          = "VNET-Tenant-Contoso"
            TenantVirtualNetworkAddressPrefix = @("172.16.1.0/16") 
            PhysicalGwVMName                  = 'CONTOSO-GW01'
            TenantVirtualSubnetId             = "VSUBNET-Tenant-Contoso-WebTier"
            TenantVirtualSubnetAddressPrefix  = @( "172.16.1.0/24" )
            DomainFQDN                        = "contoso.local"
        },
        @{
            Name                              = "Fabrikam";
            TenantVirtualNetworkName          = "VNET-Tenant-Fabrikam"
            TenantVirtualNetworkAddressPrefix = @("172.16.1.0/16") 
            PhysicalGwVMName                  = 'FABRIKAM-GW01'
            TenantVirtualSubnetId             = "VSUBNET-Tenant-Fabrikam-WebTier"
            TenantVirtualSubnetAddressPrefix  = @( "172.16.1.0/24" )
            DomainFQDN                        = "fabrikam.local"
        }
    )

    TenantvGWs           =
    @(
        @{
            Tenant                      = "Contoso"
            Type                        = 'L3'
            VirtualGwName               = 'Contoso_vGW'
            LogicalNetworkName          = "Contoso_L3_Interco_Network"
            LogicalSunetName            = "Contoso_L3_Interco_Subnet"
            VLANID                      = 1001;
            LogicalSunetAddressPrefix   = "10.127.134.0/25"
            LogicalSunetDefaultGateways = "10.127.134.1"
            LocalIpAddrGW               = "10.127.134.55"
            PeerIpAddrGW                = @( "10.127.134.65" )
            RouteDstPrefix              = @( "1.1.1.1/32" )
            #BGP Router properties  
            BGPEnabled                  = $True;
            BgpLocalExtAsNumber         = "0.64512"   
            BgpLocalBRouterId           = "10.127.134.55"   
            BgpLocalRouterIP            = @("10.127.134.55")
            BgpPeerIpAddress            = "10.127.134.65"   
            BgpPeerAsNumber             = 64521   
            BgpPeerExtAsNumber          = "0.64521"   
        },
        @{
            Tenant              = "Fabrikam"
            Type                = 'GRE'
            VirtualGwName       = 'Fabrikam_vGW'
            RouteDstPrefix      = @( "172.16.0.0/16" )
            #BGP Router properties  
            PSK                 = "1234"
            GrePeer             = "1.1.1.1"
            BGPEnabled          = $true
            BgpLocalExtAsNumber = "0.64512"   
            BgpLocalBRouterId   = "Fabrikam_vGW"   
            BgpLocalRouterIP    = @("172.16.179.179")
            BgpPeerIpAddress    = "172.16.254.50"   
            BgpPeerAsNumber     = 64521   
            BgpPeerExtAsNumber  = "0.64521"   
        }
    )
    
    TenantVMs            = 
    @(
        @{
            HypvHostname = "SDN-HOST02.SDN.LAB"
            VHDFile      = "Win2019-Core-Container.vhdx"
            Tenant       = "Contoso"
            Name         = 'Contoso-CH01'
            VMMemory             = 4GB
            VMProcessorCount     = 4
            roles        = @("ContainerHost")
            VIP          = "41.40.40.8"
            ContainersIpPool = "172.16.1.32/29"             
            NICs         = @( 
                @{ 
                    Name = "Ethernet"; IPAddress = '172.16.1.10/24'; Gateway = '172.16.1.1'; 
                    DNS = @("172.16.1.53") ; MACAddress = '00-00-00-00-00-00'; VLANID = 0 
                };
            )   

        },
        @{
            HypvHostname = "SDN-HOST01.SDN.LAB"
            VHDFile      = "Win2019-Core-Container.vhdx"
            Tenant       = "Contoso"
            Name         = 'Contoso-CH02'
            VMMemory             = 4GB
            VMProcessorCount     = 4
            roles        = @("ContainerHost")
            VIP          = "41.40.40.8"
            ContainersIpPool = "172.16.1.40/29"             
            NICs         = @( 
                @{ 
                    Name = "Ethernet"; IPAddress = '172.16.1.11/24'; Gateway = '172.16.1.1'; 
                    DNS = @("172.16.1.53") ; MACAddress = '00-00-00-00-00-00'; VLANID = 0 
                };
            )   
        },
        @{
            HypvHostname = "SDN-HOST02.SDN.LAB"
            VHDFile      = "Win2019-Core-Container.vhdx"
            Tenant       = "Fabrikam"
            Name         = 'Fabrikam-CH01'
            VMMemory             = 4GB
            VMProcessorCount     = 4
            roles        = @("ContainerHost")
            VIP          = "41.40.40.9"
            ContainersIpPool = "172.16.1.32/29"            
            NICs         = @( 
                @{ 
                    Name = "Ethernet"; IPAddress = '172.16.1.10/24'; Gateway = '172.16.1.1'; 
                    DNS = @("172.16.1.53") ; MACAddress = '00-00-00-00-00-00'; VLANID = 0 
                };
            )
        },
        @{
            HypvHostname = "SDN-HOST01.SDN.LAB"
            VHDFile      = "Win2019-Core-Container.vhdx"
            Tenant       = "Fabrikam"            
            VMMemory             = 4GB
            VMProcessorCount     = 4
            VIP          = "41.40.40.9"     
            ContainersIpPool = "172.16.1.40/29"                 
            roles        = @("ContainerHost")
            NICs         = @( 
                @{ 
                    Name = "Ethernet"; IPAddress = '172.16.1.11/24'; Gateway = '172.16.1.1'; 
                    DNS = @("172.16.1.53") ; MACAddress = '00-00-00-00-00-00'; VLANID = 0 
                };
            )   
        }
    )

    SlbVIPs                 =
    @(
        @{
            Tenant              = "Contoso"
            Name                = 'Contoso-WebRainbow'
            VIP                 = "41.40.40.8"
            VIPAllocationMethod = "static" 
            FrontendPort        = 80
            BackendPort         = 80   
            Protocol            = "TCP"
            TenantVMs           = @("Contoso-CH01", "Contoso-CH02")     
        },
        @{
            Tenant              = "Fabrikam"
            Name                = 'Fabrikam-WebRainbow'
            VIP                 = "41.40.40.9"
            VIPAllocationMethod = "static" 
            FrontendPort        = 80
            BackendPort         = 80
            Protocol            = "TCP"
            TenantVMs           = @("Fabrikam-CH01", "Fabrikam-CH02")  
        }
    )
    

    RestURI = "https://NCFABRIC.SDN.LAB"

}