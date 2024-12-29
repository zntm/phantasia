function gaussian_distribution(_value, _mean, _std)
{
    var _numerator   = power(_value - _mean, 2);
    var _denominator = power(2 * _std, 2);
    
    return power(EULER, -_numerator / _denominator);
}