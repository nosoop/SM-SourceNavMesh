/**
 * Sourcemod 1.7 Plugin Template
 */
#pragma semicolon 1
#include <sourcemod>

#include <sdktools>

#pragma newdecls required

#define PLUGIN_VERSION "0.0.0"
public Plugin myinfo = {
	name = "Navigation Mesh Utils Test Plugin",
	author = "nosoop",
	description = "Sample plugin for Navigation Mesh Utils",
	version = PLUGIN_VERSION,
	url = "https://github.com/nosoop/SM-SourceNavMesh/"
}

Handle g_hGameConf;

#include "navmesh/CNavArea.sp"
#include "navmesh/CNavMesh.sp"

public void OnMapStart() {
	LogMessage("TheNavMesh address: %08x", CNavMesh.GetAddress());
	
	if (!CNavMesh.IsLoaded()) {
		LogMessage("No navigation mesh loaded.");
	} else {
		LogMessage("Navigation mesh subversion: %d", CNavMesh.GetSubVersionNumber());
		
		char navFilename[PLATFORM_MAX_PATH];
		CNavMesh.GetFilename(navFilename, sizeof(navFilename));
		LogMessage("Loaded navigation mesh: %s", navFilename);
		
		LogMessage("Number of areas: %d", CNavMesh.GetAreaCount());
		LogMessage("Mesh minimum coordinates: %.3f, %.3f", CNavMesh.GetMinX(),
				CNavMesh.GetMinY());
		LogMessage("Grid dimensions: %d, %d (grid cell size %f)", CNavMesh.GetGridSizeX(),
				CNavMesh.GetGridSizeY(), CNavMesh.GetGridCellSize());
		LogMessage("Mesh flags: loaded? %d, out of date? %d, analyzed? %d",
				CNavMesh.IsLoaded(), CNavMesh.IsOutOfDate(), CNavMesh.IsAnalyzed());
		
		float vecOrigin[3];
		CNavArea area = CNavMesh.GetNearestNavArea(vecOrigin, true, 1000.0, false,
				false, 0);
		
		LogMessage("Navigation area near origin address: %08x", area.Address);
		LogMessage("Mesh has nodes? %b", area.HasNodes);
		
		float vecCoord[3];
		area.GetNorthwestCorner(vecCoord);
		LogMessage("Navigation area NW corner: %.3f, %.3f, %.3f",
				vecCoord[0], vecCoord[1], vecCoord[2]);
		
		area.GetSoutheastCorner(vecCoord);
		LogMessage("Navigation area SE corner: %.3f, %.3f, %.3f",
				vecCoord[0], vecCoord[1], vecCoord[2]);
		
		area.GetCenter(vecCoord);
		LogMessage("Navigation area center: %.3f, %.3f, %.3f",
				vecCoord[0], vecCoord[1], vecCoord[2]);
		
		LogMessage("id? %d", area.ID);
		
		CNavArea sameArea = CNavMesh.GetNavAreaByID(area.ID);
		LogMessage("Navigation area %d has address: %08x", area.ID, sameArea.Address);
		
		LogMessage("Center world to grid coordinates: %d, %d", CNavMesh.WorldToGridX(0.0),
				CNavMesh.WorldToGridY(0.0));
	}
	// DumpBytes(area, 1024);
}

/**
 * Dumps bytes starting near the address.
 */
stock void DumpBytes(Address address, int bytes = 128, int start = 0) {
	for (int o = start; o < bytes + start; o += 16) {
		int loadedBytes[16];
		for (int i = 0; i < 16; i++) {
			Address p = address + view_as<Address>(o + i);
			loadedBytes[i] = LoadFromAddress(p, NumberType_Int8) & 0xFF;
		}
		
		LogMessage("%08x: %02x %02x %02x %02x %02x %02x %02x %02x "
				... "%02x %02x %02x %02x %02x %02x %02x %02x",
				address + view_as<Address>(o),
				loadedBytes[0], loadedBytes[1], loadedBytes[2], loadedBytes[3], 
				loadedBytes[4], loadedBytes[5], loadedBytes[6], loadedBytes[7], 
				loadedBytes[8], loadedBytes[9], loadedBytes[10], loadedBytes[11], 
				loadedBytes[12], loadedBytes[13], loadedBytes[14], loadedBytes[15]);
	}
}