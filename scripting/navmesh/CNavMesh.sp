// Handle g_hGameConf;

// relative offsets
enum {
	m_grid = 24, // mutable CUtlVector
	m_gridCellSize = 28, // float
	m_gridSizeX = 32, // int
	m_gridSizeY = 36, // int
	m_minX = 40, // float
	m_minY = 44, // float
	m_areaCount = 48, // uint
	m_isLoaded = 52, // bool
	m_isOutOfDate = 53, // bool
	m_isAnalyzed = 54, // bool
}

methodmap CNavMesh {
	public static Address GetAddress() {
		return GameConfGetAddress(g_hGameConf, "CNavMesh");
	}
	public static int GetSubVersionNumber() {
		return NavMesh_GetSubVersionNumber();
	}
	
	public static CNavArea GetNearestNavArea(const float vecPos[3], bool anyZ,
			float maxDist, bool checkLOS, bool checkGround, int team) {
		return NavMesh_GetNearestNavAreaForPosition(vecPos, anyZ, maxDist, checkLOS,
				checkGround, team);
	}
	
	public static CNavArea GetNearestNavAreaForEntity(int entity, int nFlags, float maxDist) {
		return NavMesh_GetNearestNavAreaForEntity(entity, nFlags, maxDist);
	}
	
	public static CNavArea GetNavAreaByID(int id) {
		return NavMesh_GetNavAreaByID(id);
	}
	
	public static void RemoveNavArea(CNavArea area) {
		NavMesh_RemoveNavArea(area);
	}
	
	public static void DestroyArea(CNavArea area) {
		NavMesh_DestroyArea(area);
	}
	
	public static int WorldToGridX(float wx) {
		return NavMesh_WorldToGridX(wx);
	}
	
	public static int WorldToGridY(float wy) {
		return NavMesh_WorldToGridY(wy);
	}
	
	// properties
	
	public static float GetGridCellSize() {
		return NavMesh_LoadFromRelativeAddress(m_gridCellSize, NumberType_Int32);
	}
	
	public static int GetGridSizeX() {
		return NavMesh_LoadFromRelativeAddress(m_gridSizeX, NumberType_Int32);
	}
	
	public static int GetGridSizeY() {
		return NavMesh_LoadFromRelativeAddress(m_gridSizeY, NumberType_Int32);
	}
	
	public static float GetMinX() {
		return NavMesh_LoadFromRelativeAddress(m_minX, NumberType_Int32);
	}
	
	public static float GetMinY() {
		return NavMesh_LoadFromRelativeAddress(m_minY, NumberType_Int32);
	}
	
	public static int GetAreaCount() {
		// I brute-forced this and compared it to sourcepawn-navmesh's value.
		// I shouldn't be proud.
		return NavMesh_LoadFromRelativeAddress(m_areaCount, NumberType_Int32);
	}
	
	public static bool IsLoaded() {
		return NavMesh_LoadFromRelativeAddress(m_isLoaded, NumberType_Int8);
	}
	public static bool IsOutOfDate() {
		return NavMesh_LoadFromRelativeAddress(m_isOutOfDate, NumberType_Int8);
	}
	public static bool IsAnalyzed() {
		return NavMesh_LoadFromRelativeAddress(m_isAnalyzed, NumberType_Int8);
	}
	
	public static int GetFilename(char[] buffer, int maxlen) {
		return NavMesh_GetFilename(buffer, maxlen);
	}
}

static int NavMesh_GetSubVersionNumber() {
	static Handle s_hSDKCall;
	
	if (!s_hSDKCall) {
		StartPrepSDKCall(SDKCall_Raw);
		PrepSDKCall_SetFromConf(g_hGameConf, SDKConf_Virtual, "CNavMesh::GetSubVersionNumber");
		PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
		if (!(s_hSDKCall = EndPrepSDKCall())) {
			SetFailState("Could not create SDKCall for CNavMesh::GetSubVersionNumber");
		}
	}
	
	Address pNavMesh = CNavMesh.GetAddress();
	if (pNavMesh) {
		return SDKCall(s_hSDKCall, pNavMesh);
	}
	return 0;
}

static CNavArea NavMesh_GetNearestNavAreaForPosition(const float vecPos[3], bool anyZ,
		float maxDist, bool checkLOS, bool checkGround, int team) {
	static Handle s_hSDKCall;
	
	if (!s_hSDKCall) {
		StartPrepSDKCall(SDKCall_Raw);
		PrepSDKCall_SetFromConf(g_hGameConf, SDKConf_Signature,
				"CNavMesh::GetNearestNavAreaForPosition");
		PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_Pointer);
		PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
		PrepSDKCall_AddParameter(SDKType_Float, SDKPass_Plain);
		PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
		PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
		PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
		PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
		
		if (!(s_hSDKCall = EndPrepSDKCall())) {
			SetFailState("Could not prepare SDKCall for CNavMesh::GetNearestNavArea");
		}
	}
	
	Address pNavMesh = CNavMesh.GetAddress();
	if (pNavMesh) {
		return SDKCall(s_hSDKCall, pNavMesh, vecPos, anyZ, maxDist, checkLOS, checkGround, team);
	}
	return CNavArea(Address_Null);
}

static CNavArea NavMesh_GetNearestNavAreaForEntity(int entity, int nFlags, float maxDist) {
	static Handle s_hSDKCall;
	
	if (!s_hSDKCall) {
		StartPrepSDKCall(SDKCall_Raw);
		PrepSDKCall_SetFromConf(g_hGameConf, SDKConf_Signature,
				"CNavMesh::GetNearestNavAreaForEntity");
		PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
		PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
		
		if (!(s_hSDKCall = EndPrepSDKCall())) {
			SetFailState("Could not prepare SDKCall for CNavMesh::GetNearestNavArea");
		}
	}
	
	Address pNavMesh = CNavMesh.GetAddress();
	if (pNavMesh) {
		return SDKCall(s_hSDKCall, pNavMesh, id);
	}
	return CNavArea(Address_Null);
}

static CNavArea NavMesh_GetNavAreaByID(int id) {
	static Handle s_hSDKCall;
	
	if (!s_hSDKCall) {
		StartPrepSDKCall(SDKCall_Raw);
		PrepSDKCall_SetFromConf(g_hGameConf, SDKConf_Signature, "CNavMesh::GetNavAreaByID");
		PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
		PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
		
		if (!(s_hSDKCall = EndPrepSDKCall())) {
			SetFailState("Could not prepare SDKCall for CNavMesh::GetNavAreaByID");
		}
	}
	
	Address pNavMesh = CNavMesh.GetAddress();
	if (pNavMesh) {
		return SDKCall(s_hSDKCall, pNavMesh, id);
	}
	return CNavArea(Address_Null);
}

static int NavMesh_GetFilename(char[] buffer, int maxlen) {
	static Handle s_hSDKCall;
	
	if (!s_hSDKCall) {
		StartPrepSDKCall(SDKCall_Raw);
		PrepSDKCall_SetFromConf(g_hGameConf, SDKConf_Signature, "CNavMesh::GetFilename");
		PrepSDKCall_SetReturnInfo(SDKType_String, SDKPass_Pointer);
		
		if (!(s_hSDKCall = EndPrepSDKCall())) {
			SetFailState("Could not prepare SDKCall for CNavMesh::GetFilename");
		}
	}
	
	Address pNavMesh = CNavMesh.GetAddress();
	if (pNavMesh) {
		SDKCall(s_hSDKCall, pNavMesh, buffer, maxlen);
		return strlen(buffer);
	}
	return 0;
}

static void NavMesh_RemoveNavArea(CNavArea area) {
	static Handle s_hSDKCall;
	
	if (!s_hSDKCall) {
		StartPrepSDKCall(SDKCall_Raw);
		PrepSDKCall_SetFromConf(g_hGameConf, SDKConf_Signature, "CNavMesh::RemoveNavArea");
		PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Pointer);
		
		if (!(s_hSDKCall = EndPrepSDKCall())) {
			SetFailState("Could not prepare SDKCall for CNavMesh::RemoveNavArea");
		}
	}
	
	Address pNavMesh = CNavMesh.GetAddress();
	if (pNavMesh) {
		SDKCall(s_hSDKCall, pNavMesh, area.Address);
	}
}

static void NavMesh_DestroyArea(CNavArea area) {
	static Handle s_hSDKCall;
	
	if (!s_hSDKCall) {
		StartPrepSDKCall(SDKCall_Raw);
		PrepSDKCall_SetFromConf(g_hGameConf, SDKConf_Signature, "CNavMesh::DestroyArea");
		PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Pointer);
		
		if (!(s_hSDKCall = EndPrepSDKCall())) {
			SetFailState("Could not prepare SDKCall for CNavMesh::DestroyArea");
		}
	}
	
	Address pNavMesh = CNavMesh.GetAddress();
	if (pNavMesh) {
		SDKCall(s_hSDKCall, pNavMesh, area.Address);
	}
}

any NavMesh_LoadFromRelativeAddress(int offset, NumberType type) {
	Address p = CNavMesh.GetAddress() + view_as<Address>(offset);
	return LoadFromAddress(p, type);
}

// ported functions, no idea where valve implements them

static int NavMesh_WorldToGridX(float wx) {
	int x = RoundFloat((wx - CNavMesh.GetMinX()) / CNavMesh.GetGridCellSize());
	
	if (x < 0) {
		return 0;
	} else if (x > CNavMesh.GetGridSizeX()) {
		return CNavMesh.GetGridSizeX() - 1;
	}
	return x;
	
}

static int NavMesh_WorldToGridY(float wy) {
	int y = RoundFloat((wy - CNavMesh.GetMinY()) / CNavMesh.GetGridCellSize());
	
	if (y < 0) {
		return 0;
	} else if (y > CNavMesh.GetGridSizeY()) {
		return CNavMesh.GetGridSizeY() - 1;
	}
	return y;
	
}