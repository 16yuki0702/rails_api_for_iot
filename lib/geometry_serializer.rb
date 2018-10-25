class GeometryDeserializer
  def initialize
    factory = ::RGeo::Geographic.spherical_factory(srid: 4326)
    @base = ::Armg::WkbDeserializer.new(factory: factory)
  end

  def deserialize(mysql_geometry)
    @base.deserialize(mysql_geometry)
  end
end

class GeometrySerializer
  def initialize
    factory = ::RGeo::Geographic.spherical_factory(srid: 4326)
    @wkt_parser = RGeo::WKRep::WKTParser.new(factory, support_ewkt: true)
  end

  def serialize(value)
    if value.is_a?(String)
      value = @wkt_parser.parse(value)
    end
    value
  end
end

module ArmgConnectionAdapterExt
  def quote(value_)
    if ::RGeo::Feature::Geometry.check_type(value_)
      "ST_GeomFromWKB(0x#{::RGeo::WKRep::WKBGenerator.new(hex_format: true, little_endian: true).generate(value_)},#{value_.srid})"
    else
      super
    end
  end
end
