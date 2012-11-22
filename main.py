#!/usr/bin/env python
#
# Copyright 2007 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
import os

from google.appengine.ext import webapp
from google.appengine.ext import db
from google.appengine.ext.webapp import util
from google.appengine.ext.webapp import template


class Gallery(db.Model):
  name = db.StringProperty()
  dir = db.StringProperty()
  tags = db.StringProperty()
  description = db.StringProperty(multiline=True)

class Picture(db.Model):
  name = db.StringProperty()
  path = db.StringProperty()
  tags = db.StringProperty()
  description = db.StringProperty(multiline=True)
  gallery = db.ReferenceProperty(Gallery, collection_name='pictures')


class MainHandler(webapp.RequestHandler):
    def get(self):
        self.response.out.write('Hello world!')


class AboutPage(webapp.RequestHandler):
  def get(self):
    template_values = {
      'title1': "DIY",
      'title2': "Web Guide for App Engine",      
      'slogan': "Deploying Static Sites to App Engine",
      'message1' : "",
      }
      
    path = os.path.join(os.path.dirname(__file__), 'about.html')
    self.response.out.write(template.render(path, template_values))

class LinksPage(webapp.RequestHandler):
  def get(self):
    template_values = {
      'title1': "DIY",
      'title2': "Web Guide for App Engine",      
      'slogan': "Deploying Static Sites to App Engine",
      'message1' : "",
      }
      
    path = os.path.join(os.path.dirname(__file__), 'links.html')
    self.response.out.write(template.render(path, template_values))

class RobotsHandler(webapp.RequestHandler):
    def get(self):
        self.response.out.write('User-Agent: *\nDisallow: /nav\nDisallow: /css')

class TestHandler(webapp.RequestHandler):
    def get(self):
        gal1 = Gallery(name='montenegro', dir='01', tags='demontagu, photography, black and white photography, 6x6, medium format, 35 mm', description='')
        gal1.put()

        q = Gallery.gql("WHERE dir='03'")
        gals = q.fetch(limit=1)

        if len(gals) == 1:
            Picture(gallery=gals[0],path='18boat.jpg').put()

        
#  name = db.StringProperty()
#  path = db.StringProperty()
#  tags = db.StringProperty()
#  description = db.StringProperty(multiline=True)

        #Picture(gallery=gal1,path='01lesyeux.jpg').put()
        #Picture(gallery=gal1,path='10courtyard.jpg').put()
        #Picture(gallery=gal1,).put()
        
        self.response.out.write('OK')

def main():
    application = webapp.WSGIApplication([('/', MainHandler)
                                        , ('/index.html', MainHandler)
                                        , ('/about.html', AboutPage)
                                        , ('/links.html', LinksPage)
                                        , ('/robots.txt', RobotsHandler)
                                        , ('/test', TestHandler)
                                          ],
                                         debug=True)
    util.run_wsgi_app(application)


if __name__ == '__main__':
    main()
