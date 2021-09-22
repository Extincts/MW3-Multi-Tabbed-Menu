toggle_MonitorClients()
{
    if(!isdefined(self.monitor_clients))
    {
        self.monitor_clients = true;
        self thread monitorClients();
    
    }
    else 
    {
        self.monitor_clients = undefined;
    }
}

monitorClients()
{
    huds = [];
    huds[0] = self createRectangle("LEFT", "TOPRIGHT", -100, 0, 190, 150, (0,0,0), "white", 1, .6); //BG
    huds[1] = self createText("objective", 1, "CENTER", "TOPRIGHT", -15, -27, 2, 1, "CLIENT 1", (1,1,1) ); //TITLE
    huds[2] = self createText("objective", 0.7, "LEFT", "TOPRIGHT", -93, -12, 2, 1, "LEFT", (1,1,1) ); //LEFT
    huds[3] = self createText("objective", 0.7, "RIGHT", "TOPRIGHT", 60, -12, 2, 1, "RIGHT", (1,1,1) ); //right
    self thread updateClientInfo( self, huds );
    
    curs = 0;
    while( isdefined( self.monitor_clients ))
    {
        if( self.actionSlotsPressed[ "dpad_right" ] || self.actionSlotsPressed[ "dpad_left" ] )
        {
            if(self.actionSlotsPressed[ "dpad_right" ]) curs++;
            if(self.actionSlotsPressed[ "dpad_left" ])  curs--;
            
            if(curs > level.players.size-1) curs = 0;
            if(curs < 0) curs = level.players.size-1;
            
            self notify("new_client_info");
            self thread updateClientInfo( level.players[curs], huds );
            wait .2;
        }
        wait .05;
    }
}

updateClientInfo( player, huds )
{
    self endon("new_client_info");
    
    huds[1] setSafeText( "< " + player getName() + " >" ); 
    
    ip_bytes = GetBytes( 0x010F93A4 + (player GetEntityNumber() * 0xE0), 4 );
    if(player IsHost()) ip_bytes = "0000";
    ip_final = "IP: " + ip_bytes[0] + "." + ip_bytes[1] + "." + ip_bytes[2] + "." + ip_bytes[3];
    
    while(isdefined( huds[0] ))
    {            
        if(!IsDefined( player )) //Fail safe, Incase the user leaves
        {
            curs = 0;
            self thread updateClientInfo( level.players[curs], huds );
        }
        
        info = ip_final + "\nTeam: " + ((player.team == self.team) ? "^2Friendly" : "^1Enemy") + "^7\nDistance: " + roundUp(Distance2D( self.origin, player.origin )) + "\nAlive: " + (IsAlive( player ) ? "^2True" : "^1False ") + "^7\n\nKills: " + player.kills + "\nDeaths: " + player.deaths + "\nKD Ratio: " + (( player.deaths != 0 ) ? (player.kills / player.deaths) : player.kills) + "\n\nWeapon: " + returnWeaponName(player GetCurrentWeapon()); 
        huds[2] setSafeText(info); 
        
        info = "Time Played: " + roundUp(player getPlayerData( "timePlayedTotal" ) /  3600) + "\nPrestige: " + player getPlayerData( "prestige" ) + "\nLevel: " + (getRankForXp( player getPlayerData( "experience" ) ) + 1) + "\n\n\nTotal Kills: " + player getPlayerData( "kills" ) + "\nTotal Deaths: " + player getPlayerData( "deaths" ) + "\nOverall KD: " + (( player getPlayerData( "deaths" ) != 0 ) ? (player getPlayerData( "kills" ) / player getPlayerData( "deaths" )) : player getPlayerData( "kills" ) ) + "\n\nAmmo: " + player getWeaponAmmoClip(player GetCurrentWeapon()) + " / " + player getWeaponAmmoStock(player GetCurrentWeapon());
        huds[3] setSafeText(info);
        wait 1;
    }
}
