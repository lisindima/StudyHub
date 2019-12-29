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
            NavigationLink(destination: KeyboardObservingLicense()) {
                Text("Keyboard Observing")
            }
            NavigationLink(destination: FloatingButtonLicense()) {
                Text("FloatingButton")
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

struct KeyboardObservingLicense: View {
    var body: some View {
        VStack {
            ScrollView {
                Text("""
                MIT License

                Copyright (c) 2019 Nick Fox

                Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

                The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

                THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
                """).padding()
            }
        }
        .navigationBarTitle(Text("Keyboard Observing"), displayMode: .inline)
        .navigationBarItems(trailing: Button (action: {
                UIApplication.shared.open(URL(string: "https://github.com/nickffox/KeyboardObserving")!)
            })
            {
                Image(systemName: "safari")
                    .imageScale(.large)
        })
    }
}

struct FloatingButtonLicense: View {
    var body: some View {
        VStack {
            ScrollView {
               Text("""
                MIT License

                Copyright (c) 2016 exyte <info@exyte.com>

                Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

                The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

                THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
                """).padding()
            }
        }
        .navigationBarTitle(Text("FloatingButton"), displayMode: .inline)
        .navigationBarItems(trailing: Button (action: {
                UIApplication.shared.open(URL(string: "https://github.com/exyte/FloatingButton")!)
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
