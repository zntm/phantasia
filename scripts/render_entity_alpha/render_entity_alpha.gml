function render_entity_alpha(_alpha, _immunity_frame)
{
    return _alpha * ((cos(_immunity_frame / 16) + 1) / 2);
}
