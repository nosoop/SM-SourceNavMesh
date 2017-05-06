
// offsets from nav_area.h
// constants: MAX_NAV_TEAMS = 2, NUM_DIRECTIONS = 4
enum CNavAreaOffset {
	// CNavAreaCriticalData
	m_nwCorner = 0, // vector -- does Z get discarded?
	m_seCorner = 12, // vector
	m_invDxCorners = 24, // float
	m_invDyCorners = 28, // float
	m_neZ = 32, // float
	m_swZ = 36, // float
	
	m_center = 40, // vector
	
	m_playerCount = 52, // uint[MAX_NAV_TEAMS = 2]
	m_isBlocked = 54, // bool[MAX_NAV_TEAMS = 2]
	m_marker = 56, // uint
	m_totalCost = 60, // float
	m_costSoFar = 64, // float
	
	m_nextOpen = 68, // CNavArea pointer
	m_prevOpen = 72, // CNavArea pointer
	m_openMarker = 76, // uint
	
	m_attributeFlags = 80, // int
	
	m_connect = 84, // NavConnectVector[NUM_DIRECTIONS = 4]
	
	m_ladder = 100, // NavLadderConnectVector[CNavLadder::NUM_LADDER_DIRECTIONS = 2]
	
	m_elevatorAreas = 108, // NavConnectVector
	
	m_nearNavSearchMarker = 112, // uint
	m_parent = 116, // CNavArea pointer
	m_parentHow = 120, // NavTraverseType
	m_pathLengthSoFar = 124, // float
	m_elevator = 128, // CFuncElevator pointer
	
	// m_isReset = 132, // ??
	
	m_id = 136, // pulled from disassembly @_ZNK8CNavArea4SaveER10CUtlBufferj, mov 0x88 ...
	m_debugid = 140,
	
	m_place = 144,
	
	m_isUnderwater = 156,
	
	
	/*m_id, // uint
	m_debugid, // uint
	m_place, // pointer
	m_blockedTimer, // pointer */
	// m_isUnderwater = 160, // bool
	// m_isBattlefront = 164, // bool
}

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
		public get() {
			return NavArea_HasNodes(this.Address);
		}
	}
	
	property int ID {
		public get() {
			return NavArea_LoadFromRelativeAddress(this, m_id, NumberType_Int32);
		}
	}
	
	public void GetNorthwestCorner(float vecCorner[3]) {
		NavArea_LoadVectorFromRelativeAddress(this, m_nwCorner, vecCorner);
	}
	
	public void GetSoutheastCorner(float vecCorner[3]) {
		NavArea_LoadVectorFromRelativeAddress(this, m_seCorner, vecCorner);
	}
	
	public float GetInvDxCorners() {
		return NavArea_LoadFromRelativeAddress(this, m_invDxCorners, NumberType_Int32);
	}
	
	public float GetInvDyCorners() {
		return NavArea_LoadFromRelativeAddress(this, m_invDyCorners, NumberType_Int32);
	}
	
	public void GetCenter(float vecCenter[3]) {
		NavArea_LoadVectorFromRelativeAddress(this, m_center, vecCenter);
	}
}

static bool NavArea_HasNodes(Address pNavArea) {
	static Handle s_hSDKCall;
	
	if (!s_hSDKCall) {
		StartPrepSDKCall(SDKCall_Raw);
		PrepSDKCall_SetFromConf(g_hGameConf, SDKConf_Signature,
				"CNavArea::HasNodes");
		PrepSDKCall_SetReturnInfo(SDKType_Bool, SDKPass_Plain);
		
		if (!(s_hSDKCall = EndPrepSDKCall())) {
			SetFailState("Could not prepare SDKCall for CNavArea::HasNodes");
		}
	}
	
	if (pNavArea) {
		return SDKCall(s_hSDKCall, pNavArea);
	}
	return false;
}

any NavArea_LoadFromRelativeAddress(CNavArea area, CNavAreaOffset offset, NumberType type) {
	Address p = area.Address + view_as<Address>(offset);
	return LoadFromAddress(p, type);
}

void NavArea_LoadVectorFromRelativeAddress(CNavArea area, CNavAreaOffset offset, float buffer[3]) {
	for (int i = 0; i < 3; i++) {
		CNavAreaOffset p = view_as<CNavAreaOffset>(view_as<int>(offset) + (i * 4));
		buffer[2-i] = NavArea_LoadFromRelativeAddress(area, p, NumberType_Int32);
	}
}