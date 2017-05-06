/**
 * Navigation Mesh Library
 * 
 * Exposes the game's navigation mesh functions to SourceMod.  Uses the game's in-memory copy of
 * the navigation mesh, so you don't have your own "read-only" copy.
 */
#pragma semicolon 1
#include <sourcemod>

#include <sdktools>

#pragma newdecls required
#include <stocksoup/log_server>

#define PLUGIN_VERSION "0.0.0"
public Plugin myinfo = {
	name = "Navigation Mesh Utilities",
	author = "nosoop",
	description = "Exposes the game's navigation mesh functions to SourceMod.",
	version = PLUGIN_VERSION,
	url = "https://github.com/nosoop/SM-NavMesh/"
}

Handle g_hGameConf;

#include "navmesh/CNavArea.sp"
#include "navmesh/CNavMesh.sp"

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max) {
	CreateNative("CNavMesh.GetAddress", Native_Mesh_GetAddress);
	CreateNative("CNavMesh.GetSubVersionNumber", Native_Mesh_GetSubVersionNumber);
	CreateNative("CNavMesh.GetNearestNavArea", Native_Mesh_GetNearestNavArea);
	
	// CreateNative("CNavMesh.GetNearestNavAreaForEntity", Native_NavMesh_GetNearestNavAreaForEntity);
	
	CreateNative("CNavMesh.GetNavAreaByID", Native_Mesh_GetNavAreaByID);
	
	CreateNative("CNavMesh.RemoveNavArea", Native_Mesh_RemoveNavArea);
	CreateNative("CNavMesh.DestroyArea", Native_Mesh_DestroyArea);
	
	CreateNative("CNavMesh.IsLoaded", Native_Mesh_IsLoaded);
	CreateNative("CNavMesh.IsOutOfDate", Native_Mesh_IsOutOfDate);
	CreateNative("CNavMesh.IsAnalyzed", Native_Mesh_IsAnalyzed);
	
	
	RegPluginLibrary("navmesh_utils");
	return APLRes_Success;
}

public int Native_Mesh_GetAddress(Handle plugin, int argc) {
	return view_as<int>(CNavMesh.GetAddress());
}

public int Native_Mesh_GetSubVersionNumber(Handle plugin, int argc) {
	return view_as<int>(CNavMesh.GetSubVersionNumber());
}

public int Native_Mesh_GetNearestNavArea(Handle plugin, int argc) {
	float vecOrigin[3], maxDist;
	bool anyZ, checkLOS, checkGround;
	int team;
	
	GetNativeArray(1, vecOrigin, sizeof(vecOrigin));
	anyZ = GetNativeCell(2);
	maxDist = GetNativeCell(3);
	checkLOS = GetNativeCell(4);
	checkGround = GetNativeCell(5);
	team = GetNativeCell(6);
	
	return view_as<int>(CNavMesh.GetNearestNavArea(vecOrigin, anyZ, maxDist, checkLOS,
			checkGround, team));
}

public int Native_Mesh_GetNavAreaByID(Handle plugin, int argc) {
	int id = GetNativeCell(1);
	return view_as<int>(CNavMesh.GetNavAreaByID(id));
}

public int Native_Mesh_RemoveNavArea(Handle plugin, int argc) {
	CNavArea area = GetNativeCell(1);
	return view_as<int>(CNavMesh.RemoveNavArea(area));
}

public int Native_Mesh_DestroyArea(Handle plugin, int argc) {
	CNavArea area = GetNativeCell(1);
	return view_as<int>(CNavMesh.DestroyArea(area));
}

public int Native_Mesh_IsLoaded(Handle plugin, int argc) {
	return view_as<int>(CNavMesh.IsLoaded());
}
public int Native_Mesh_IsOutOfDate(Handle plugin, int argc) {
	return view_as<int>(CNavMesh.IsOutOfDate());
}
public int Native_Mesh_IsAnalyzed(Handle plugin, int argc) {
	return view_as<int>(CNavMesh.IsAnalyzed());
}

public int Native_Mesh_GetFilename(Handle plugin, int argc) {
	int maxlen;
	
	maxlen = GetNativeCell(2);
	char[] buffer = new char[maxlen];
	
	int result = CNavMesh.GetFilename(buffer, maxlen);
	
	SetNativeString(1, buffer, maxlen, true);
	
	return result;
}