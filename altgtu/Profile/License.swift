//
//  License.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 28.11.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct License: View {
    var body: some View {
        Form {
            NavigationLink(destination: URLImageLicense()) {
                Text("URLImage")
            }
            NavigationLink(destination: LottieLicense()) {
                Text("Lottie")
            }
            NavigationLink(destination: ProtocolBuffersLicense()) {
                Text("Protocol Buffers")
            }
        }
        .navigationBarTitle(Text("Лицензии"), displayMode: .inline)
    }
}

struct URLImageLicense: View {
    var body: some View {
        VStack {
            ScrollView {
                Text("""
                    MIT License

                    Copyright (c) 2019 Dmytro Anokhin

                    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

                    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

                    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
                    """).padding()
            }
        }
        .navigationBarTitle(Text("URLImage"), displayMode: .inline)
        .navigationBarItems(trailing: Button (action: {
                UIApplication.shared.open(URL(string: "https://github.com/dmytro-anokhin/url-image")!)
            })
            {
                Image(systemName: "safari")
                    .imageScale(.large)
        })
    }
}

struct LottieLicense: View {
    var body: some View {
        VStack {
            ScrollView {
                Text("""
                    Copyright 2019 Airbnb, Inc.

                    Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

                    https://www.apache.org/licenses/LICENSE-2.0

                    Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
                    """).padding()
            }
        }
        .navigationBarTitle(Text("Lottie"), displayMode: .inline)
        .navigationBarItems(trailing: Button (action: {
                UIApplication.shared.open(URL(string: "https://github.com/airbnb/lottie-ios")!)
            })
            {
                Image(systemName: "safari")
                    .imageScale(.large)
        })
    }
}

struct ProtocolBuffersLicense: View {
    var body: some View {
        VStack {
            ScrollView {
                Text("""
                    Copyright 2019 Google Inc.  All rights reserved.

                    Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

                        * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
                        * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
                        * Neither the name of Google Inc. nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

                    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

                    Code generated by the Protocol Buffer compiler is owned by the owner of the input file used when generating it.  This code is not standalone and requires a support library to be linked with it. This support library is itself covered by the above license.
                    """).padding()
            }
        }
        .navigationBarTitle(Text("Protocol Buffers"), displayMode: .inline)
        .navigationBarItems(trailing: Button (action: {
                UIApplication.shared.open(URL(string: "https://github.com/protocolbuffers/protobuf")!)
            })
            {
                Image(systemName: "safari")
                    .imageScale(.large)
        })
    }
}

struct License_Previews: PreviewProvider {
    static var previews: some View {
        License()
    }
}
