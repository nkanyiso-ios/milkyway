

enum JsonData {
    static let validResponse = """
           {
               "collection": {
                   "version": "1.0",
                   "links": [
                       {
                           "rel": "next",
                           "prompt": "Next",
                           "href": "http://images-api.nasa.gov/search?page=2&q=%22%22"
                       }
                   ],
                   "metadata": {
                       "total_hits": 5977
                   },
                   "href": "http://images-api.nasa.gov/search?q=%22%22",
                   "items": [
                       {
                           "href": "https://images-assets.nasa.gov/image/ARC-2002-ACD02-0056-22/collection.json",
                           "data": [
                               {
                                   "description": "VSHAIP test in 7x10ft#1 W.T. (multiple model configruations) V-22 helicopter shipboard aerodynamic interaction program: L-R seated Allen Wadcox, (standind) Mark Betzina, seated in front of computer Gloria Yamauchi, in background Kurt Long.",
                                   "nasa_id": "ARC-2002-ACD02-0056-22",
                                   "media_type": "image",
                                   "title": "ARC-2002-ACD02-0056-22",
                                   "date_created": "2002-03-20T00:00:00Z",
                                   "photographer": "Tom Trower",
                                   "keywords": [
                                       "VSHAIP",
                                       "V-22"
                                   ],
                                   "center": "ARC"
                               }
                           ],
                           "links": [
                               {
                                   "rel": "preview",
                                   "href": "https://images-assets.nasa.gov/image/ARC-2002-ACD02-0056-22/ARC-2002-ACD02-0056-22~thumb.jpg",
                                   "render": "image"
                               }
                           ]
                       }
            ]
        }
    }
    """
    static let invalidResponse = """
        {
        badjson
        }
        """
}
