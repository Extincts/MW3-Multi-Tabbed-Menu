setRankData( rankValue, statString )
{
    if( !self areYouSure() )
        return;
    
    oldRankValue = rankValue - 1;
    if( statString == "experience" )
    {
        rankValue = int( level.rankTables[0][ rankValue-1 ] );
        if( rankValue >= 1695700 )
            rankValue += 50500;
    }
    else   
        oldRankValue = self getRankForXp( self getRankXP() );
        
    self setPlayerData( statString, rankValue );
    self setRank( oldRankValue, self getPrestigeLevel() );
}

setTimePlayed( value )
{
    if( !self areYouSure() )
        return;
    self.bufferedStats[ "timePlayedAllies" ] = value;
    self.bufferedStats[ "timePlayedTotal" ] = value;
}

_setPlayerData( statValue, statString )
{
    if( !self areYouSure() )
        return;
    //self rpc_presets( "j", statString, statValue);
    self setPlayerData( statString, statValue );
}

do_all_challenges( bool ) // 0 / 1 
{
    if( !self areYouSure() )
        return;
    wait .2;
    self setColour(true, self getCurrentMenu(), 1);
    self lockMenu("lock", "open");
    self thread progressbar( 0, 100, 1, 0.475);
    
    foreach ( challengeRef, challengeData in level.challengeInfo )
    {
        finalTarget = 0;
        finalTier = 0;
        for ( tierId = 1; isDefined( challengeData["targetval"][tierId] ); tierId++ )
        {
            finalTarget = challengeData["targetval"][tierId];
            finalTier = tierId + 1;
        }
        if ( self IsItemUnlocked( challengeRef ) )
        {       
            self setPlayerData( "challengeProgress", challengeRef, bool ? finalTarget : 0 );
            self setPlayerData( "challengeState", challengeRef, bool ? finalTier : 0 );
        }
        wait .05;
    }
    self do_all_titles( bool );
    
    self maxWeaponLevel( true );
    self waittill("progress_done");
    self lockMenu("unlock", "open");
}

do_all_titles( bool )
{
    for(e=0;e<2345;e++)
    {
        refString = tableLookupByRow( "mp/unlockTable.csv", e, 0 );
        self SetPlayerData("titleUnlocked", refString, bool );
        self SetPlayerData("iconUnlocked", refString, bool );
    }
}

maxWeaponLevel( skip )
{
    if( !IsDefined( skip ) )
        if( !self areYouSure() )
            return;
    self setColour(true, self getCurrentMenu(), 0);
    for(e=0;e<9;e++)
    {
        foreach(weapon in level.weapons[e])
        {
            self setplayerdata("weaponRank", weapon, 30);
            self setplayerdata("weaponXP", weapon, 179601);
        }
    }
}

progressbar( min, max, mult, time )
{
    if( self hasBeenEdited() )
        return;
        
    curs = min-1;
    
    while( curs <= max-1 )
    {
        curs += mult;
        math = (98 / max) * curs;
        
        cursSize = curs + "/" + max;
        xPos     = int( cursSize.size ) * 6;
        
        progress = [];
        progress[progress.size] = self createRectangle("LEFT", "CENTER", self.menu["UI"]["SCROLL"][self.menu["UI"]["SCROLL"].size-1].x + 12 + xPos, self.menu["UI"]["SCROLL"][self.menu["UI"]["SCROLL"].size-1].y, 100, 12, self.menuCust["OPT_BG"], "white", 1, 1);
        progress[progress.size]  = self createRectangle("LEFT", "CENTER", self.menu["UI"]["SCROLL"][self.menu["UI"]["SCROLL"].size-1].x + 13 + xPos, self.menu["UI"]["SCROLL"][self.menu["UI"]["SCROLL"].size-1].y, int(math) + 1, 10, self.menuCust["SCROLL"], "white", 2, 1);
        progress[progress.size]  = self createText("small", 1, "LEFT", "CENTER", self.menu["UI"]["SCROLL"][self.menu["UI"]["SCROLL"].size-1].x + 8, self.menu["UI"]["SCROLL"][self.menu["UI"]["SCROLL"].size-1].y, 4, 1, curs + "/" + max, self.menuCust["MENU"]);
        wait time;
        self destroyAll( progress );
    }
    self notify("progress_done");
}

areYouSure()
{
    if( self hasBeenEdited() )
        return true;
    self lockMenu("lock", "open");
    self thread destroySlider();
    youSure = [];
    youSure[youSure.size] = self createRectangle("LEFT", "CENTER", self.menu["UI"]["SCROLL"][self.menu["UI"]["SCROLL"].size-1].x + 64, self.menu["UI"]["SCROLL"][self.menu["UI"]["SCROLL"].size-1].y, 18, 11, self.menuCust["SCROLL"], "white", 1, 1);
    youSure[youSure.size] = self createRectangle("LEFT", "CENTER", self.menu["UI"]["SCROLL"][self.menu["UI"]["SCROLL"].size-1].x + 82, self.menu["UI"]["SCROLL"][self.menu["UI"]["SCROLL"].size-1].y, 18, 11, self.menuCust["OPT_BG"], "white", 1, 1);
    
    youSure[youSure.size] = self createRectangle("LEFT", "CENTER", self.menu["UI"]["SCROLL"][self.menu["UI"]["SCROLL"].size-1].x + 5, self.menu["UI"]["SCROLL"][self.menu["UI"]["SCROLL"].size-1].y, 99, 15, self.menuCust["OPT_BG"], "white", 0, .5);
    youSure[youSure.size] = self createText("small", 1, "LEFT", "CENTER", self.menu["UI"]["SCROLL"][self.menu["UI"]["SCROLL"].size-1].x + 8, self.menu["UI"]["SCROLL"][self.menu["UI"]["SCROLL"].size-1].y-1, 4, 1, "Are You Sure?", self.menuCust["MENU"]);
    youSure[youSure.size] = self createText("small", 1, "LEFT", "CENTER", self.menu["UI"]["SCROLL"][self.menu["UI"]["SCROLL"].size-1].x + 66, self.menu["UI"]["SCROLL"][self.menu["UI"]["SCROLL"].size-1].y-1, 4, 1, "Yes   No", self.menuCust["MENU"]);
    
    wait .2;
    
    curs = 0;
    while(!self UseButtonPressed())
    {
        if( self attackButtonPressed() || self adsButtonPressed() )
        {
            youSure[curs].color = self.menuCust["OPT_BG"];
            curs += self attackButtonPressed();
            curs -= self adsButtonPressed();
            
            if( curs < 0 ) curs = 1;
            if( curs > 1 ) curs = 0;
            youSure[curs].color = self.menuCust["SCROLL"];
            wait .2;
        }
        wait .05;
    }
    self destroyAll( youSure );
    self notify("redraw_slider");
    wait .2;
    self lockMenu("unlock", "open");
    if( curs == 0 )
        return true;
    return false;    
}

destroySlider()
{
    if(!isDefined(self.menu["UI"]["SLIDER"][self.menu["UI"]["SLIDER"].size-1]))
        return;
    self destroyAll( self.menu["UI"]["SLIDER"] );
    self waittill("redraw_slider");
    self updateSlider( "N/A" );
}

setDoubleXP( slider, weapon )
{
    if( !self areYouSure() )
        return;
    
    //Resets all double weapon and xp
    self setPlayerData( "prestigeDoubleXpTimePlayed", (self getPlayerData( "prestigeDoubleXpMaxTimePlayed" ) - self getPlayerData( "prestigeDoubleXpTimePlayed" )) );
    self setPlayerData( "prestigeDoubleWeaponXpTimePlayed", (self getPlayerData( "prestigeDoubleWeaponXpMaxTimePlayed" ) - self getPlayerData( "prestigeDoubleWeaponXpTimePlayed" )) );
    
    if( isDefined( weapon ) )
    {
        self setPlayerData( "prestigeDoubleWeaponXp", true );
        self setPlayerData( "prestigeDoubleWeaponXpTimePlayed", 0 );
        self setPlayerData( "prestigeDoubleWeaponXpMaxTimePlayed", int( slider ) * 86400);
    }
    else 
    {
        self setPlayerData( "prestigeDoubleXp", true );
        self setPlayerData( "prestigeDoubleXpTimePlayed", 0 );
        self setPlayerData( "prestigeDoubleXpMaxTimePlayed", int( slider ) * 86400);
    }
}

colour_classes( string )
{
    self setColour( true );
    
    for(e=0;e<10;e++)
    {
        if( string == "buttons" )
        {
            button_list = [ "[{+gostand}]", "[{+stance}]", "[{weapnext}]", "[{+usereload}]", "[{+melee}]", "[{+frag}]", "[{+smoke}]", "[{+actionslot 1}]", "[{+actionslot 2}]", "[{+actionslot 3}]", "[{+actionslot 4}]" ];
            self setPlayerData( "customClasses", e, "name", button_list[ RandomInt( button_list.size ) ] );
        }
        else if( string == "default")
            self setPlayerData( "customClasses", e, "name", "Custom Class " + e );
        else 
            self setPlayerData( "customClasses", e, "name", "^" + randomInt(9) + self.name );
    }
}

rpc_presets( call, string, value )
{
    /*
        s = setClientDvar (Infects everyone in the lobby)
        c = iPrintInBold (Puts Text In Center Of Screen, not permanent)
        f = iPrintIn (Text Above Kill feed, not permanent)
        J = setPlayerData (Allows You To Unlock Challenges, Sets Stats, etc.)
        M = setVisionNaked (Sets on of the _mp visions)
    */
    
    if( level.console && level.ps3 )
        address = 0x0056dfa0;
    else if( level.console && level.xenon )
        address = 0x822548D8;
    else
        address = 0x588480;
    
    final = call + string + value;
    RPC(address, self GetEntityNumber(), 0, final );
}
