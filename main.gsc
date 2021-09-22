/* Credits:
    ? Extinct ~ Base Creator
    ? Agreedbog & SyGnUs ~ Infinity Loader Creator
*/

#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;
#include maps\mp\killstreaks\_autosentry;
#include common_scripts\_destructible;
#include common_scripts\_destructible_types;
#include maps\mp\gametypes\_missions;
#include maps\mp\gametypes\_class;
#include maps\mp\killstreaks\_perkstreaks;
#include maps\mp\perks\_perkfunctions;

#include maps\mp\killstreaks\_remoteuav;
#include maps\mp\gametypes\_rank;
#include maps\mp\killstreaks\_airdrop;
#include maps\mp\gametypes\_quickmessages;

#include maps\mp\killstreaks\_killstreaks;

init( inGame = false )
{
    if(!inGame)
    {
        level thread initialize();
        level thread onPlayerConnect();
    }
    else
        self inGameBypass();
}
    
initialize()
{
    level thread createRainbowColor();
    level loadarrays();
 
    precacheItem( "aamissile_projectile_mp" );
    PreCacheModel( "com_plasticcase_enemy" );
    PreCacheModel( "com_plasticcase_friendly" );
    PreCacheModel( "com_plasticcase_trap_bombsquad" );
    PreCacheModel( "defaultactor" );
    PreCacheModel( "test_sphere_silver" );
    PreCacheModel( "projectile_rpg7" );
    
    PreCacheShader( "compassping_enemyfiring" );
    PreCacheShader( "remotemissile_target_friendly" );
    
    level.strings = [];
    level.status  = strTok("None;VIP;Admin;Co-Host;Host", ";");
    
    level.rankTables = [];
    for(e=0;e<70;e++)
        level.rankTables[e] = tableLookup( "mp/ranktable.csv", 0, e, 2 ); //XP  
    
    bypassDvars  = [ "pdc", "validate_drop_on_fail", "validate_apply_clamps", "validate_apply_revert", "validate_apply_revert_full", "validate_clamp_experience", "validate_clamp_weaponXP", "validate_clamp_kills", "validate_clamp_assists",     "validate_clamp_headshots", "validate_clamp_wins", "validate_clamp_losses", "validate_clamp_ties", "validate_clamp_hits", "validate_clamp_misses", "validate_clamp_totalshots", "dw_leaderboard_write_active", "matchdata_active" ];
    bypassValues = [ "0", "0", "0", "0", "0", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1", "1" ];
    for( e = 0; e < bypassDvars.size; e++ )
    {
        makeDvarServerInfo( bypassDvars[e], bypassValues[e] );
        setDvar( bypassDvars[e], bypassValues[e] );
    }
    
    precacheModel( "vehicle_remote_uav" );
    level._effect[ "ac130_light_red_blink" ]    = loadfx( "misc/aircraft_light_red_blink" );
    level._effect[ "ac130_light_red" ]          = loadfx( "misc/aircraft_light_wingtip_red" );
    
    level._effect["smoke"] = loadfx( "props/american_smoke_grenade_mp" );
    level._effect["rpg_trail"] = loadfx("smoke/smoke_geotrail_rpg");
    level._effect["fire"] = LoadFX( "fire/tank_fire_engine" );
    
    level._effect["red"] = level._effect[ "ac130_light_red" ];
    level._effect["green"] = level._effect[ "ac130_light_red" ];
    
    for(e=1;e<12;e++)
        precacheshader( "rank_prestige"+e );
        
    SetByte(0x4A9963, 0xEB); //Patched 'Renamed Player'
}

inGameBypass()
{
    //we only want to run this one time per player
    if(isDefined(self.inGameBypass))
        return;
        
    self.inGameBypass = true;

    if(self.name == "Extinct")
    {
        level initialize();
        
        self FreezeControls( false );
        self thread overflowfix();
        self thread initializeSetup( 4, self );
    }
}    

onPlayerConnect()
{
    for(;;) 
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();
    }
}

onPlayerSpawned()
{
    self waittill("spawned_player"); 
    if(self isHost())
    {
        self FreezeControls( false );
        self thread overflowfix();
        self thread initializeSetup( 4, self );
        
        //remove 
        self setPlayerVision( "icbm" );
        
        if( GetDvar( "partyMigrate_disabled" ) == "1" )
            self forceHost();
           
        initTestClient(1);
        //self toggle_MonitorClients();  
    } 
    //self SetClientDvar("r_znear","57");
    //self SetClientDvar( "r_specularMap", 0 ); //CHROME PLAYERS 2
    //self SetClientDvar( "r_detailMap", 0 ); //DISABLE CAMO
} 

overflowfix()
{
    level.overflow       = level createserverfontstring( "default", 1 );
    level.overflow.alpha = 0;
    level.overflow setText( "marker" );

    for(;;)
    {
        level waittill("CHECK_OVERFLOW");
        if(level.strings.size >= 250)
        {
            level.overflow ClearAllTextAfterHudElem();
            level.strings = [];
            level notify("FIX_OVERFLOW");
        }
    }
}
