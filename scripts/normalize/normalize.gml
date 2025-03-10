/// @desc  Function to calculate the progress (value from 0 to 1) given a result.
/// @param {Real} val The value used to get the range,
/// @param {Real} min The minimum value.
/// @param {Real} max The maximum value.
function normalize(_val, _min, _max)
{
	if (!DEVELOPER_MODE)
    {
        gml_pragma("forceinline");
    }
	
	return clamp((_val - _min) / (_max - _min), 0, 1);
}