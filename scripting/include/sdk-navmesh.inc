#if defined __sdk_navmesh_included
	#endinput
#endif

#define __sdk_navmesh_included

methodmap CNavArea {
	public CNavArea(Address pArea) {
		return view_as<CNavArea>(pArea);
	}
	
	property Address Address {
		public get() {
			return view_as<Address>(this);
		}
	}
	
	property bool HasNodes {
		public native get();
	}
	
	property int ID {
		public native get();
	}
	
	public native void GetNorthwestCorner(float vecCorner[3]);
	public native void GetSoutheastCorner(float vecCorner[3]);
	
	public native float GetInvDxCorners();
	public native float GetInvDyCorners();
	
	public native void GetCenter(float vecCenter[3]);
}

methodmap CNavMesh {
	public static native Address GetAddress();
	public static native int GetSubVersionNumber();
	
	public static native CNavArea GetNearestNavArea(const float vecPos[3], bool anyZ,
			float maxDist, bool checkLOS, bool checkGround, int team);
	
	public static native CNavArea GetNearestNavAreaForEntity(int entity, int nFlags,
			float maxDist);
	
	public static native CNavArea GetNavAreaByID(int id);
	
	public static native void RemoveNavArea(CNavArea area);
	
	public static native void DestroyArea(CNavArea area);
	
	public static native void WorldToGridX(float wx);
	
	public static native void WorldToGridY(float wy);
	
	// properties
	
	public static native float GetGridCellSize();
	public static native int GetGridSizeX();
	public static native int GetGridSizeY();
	
	public static native float GetMinX();
	public static native float GetMinY();
	
	public static native int GetAreaCount();
	
	public static native bool IsLoaded();
	public static native bool IsOutOfDate();
	public static native bool IsAnalyzed();
	
	public static native int GetFilename(char[] buffer, int maxlen);
}