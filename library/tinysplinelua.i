%module tinysplinelua

// Map std::vector<tinyspline::rational> to Lua table.
%typemap(out) std::vector<tinyspline::rational> * {
	const int size = $1->size();
	lua_createtable(L, size, 0);
	for (int i = 0; i < size; i++) {
		lua_pushnumber(L, (*$1)[i]);
		lua_rawseti(L, -2, i+1);
	}
	return 1;
}

// Map Lua table to std::vector<tinyspline::rational>.
%typemap(in) std::vector<tinyspline::rational> * (int idx) %{
	$1 = new std::vector<tinyspline::rational>();
	idx = lua_gettop(L);
	lua_pushnil(L);
	while (lua_next(L, idx)) {
		$1->push_back(lua_tonumber(L, -1));
		lua_pop(L, 1);
	}
%}

// Cleanup memory allocated by typemaps.
%typemap(freearg) std::vector<tinyspline::rational> * {
	delete $1;
}

//********************************************************
//*                                                      *
//* BSpline (Lua)                                        *
//*                                                      *
//********************************************************
%ignore tinyspline::BSpline::operator=;

//********************************************************
//*                                                      *
//* DeBoorNet (Lua)                                      *
//*                                                      *
//********************************************************
%ignore tinyspline::DeBoorNet::operator=;

//********************************************************
//*                                                      *
//* SWIG base file                                       *
//*                                                      *
//********************************************************
%include "tinyspline.i"
