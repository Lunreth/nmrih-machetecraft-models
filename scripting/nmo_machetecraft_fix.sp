#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

bool g_bEnabled;

public Plugin myinfo =
{
	name = "[NMRIH] NMO_MacheteCraft Models",
	author = "Ulreth",
	description = "Custom models for nmo_machetecraft_...",
	version = "1.1",
	url = "https://steamcommunity.com/groups/lunreth-laboratory"
};

public void OnMapStart()
{
	char map[PLATFORM_MAX_PATH];
	GetCurrentMap(map, sizeof(map));

	if(StrContains(map, "nmo_machetecraft") != -1)
    {
        PrecacheModel("models/nmr_zombie/runner.mdl");
        g_bEnabled = true;
    }
    else
    {
        g_bEnabled = false;
    }
}

public void OnEntityCreated(int entity, const char[] classname)
{
	if(!g_bEnabled)
        return;

	if(StrEqual(classname, "npc_nmrih_runnerzombie"))
		SDKHook(entity, SDKHook_SpawnPost, OnRunnerSpawned);
}

public void OnRunnerSpawned(int zombie)
{
	char targetname[64];
	GetEntPropString(zombie, Prop_Send, "m_iName", targetname, sizeof(targetname));

	if ((StrEqual(targetname, "special1")) || (StrEqual(targetname, "special2")) || (StrEqual(targetname, "special3")))
	{
		CreateTimer(1.0, Timer_SetModel, zombie);
	}
}

public Action Timer_SetModel(Handle timer, int zombie)
{
	SetEntProp(zombie, Prop_Send, "m_nModelIndex", PrecacheModel("models/nmr_zombie/runner.mdl"));
	SetEntityModel(zombie, "models/nmr_zombie/runner.mdl");
}