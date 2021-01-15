import React, { Component } from 'react'
import { StyleSheet, Text, View, Image, TouchableWithoutFeedback, StatusBar, TextInput, SafeAreaView, Keyboard, TouchableOpacity, KeyboardAvoidingView, TouchableOpacityBase, CheckBox } from 'react-native'
export default class Login extends Component {
    render() {
        return (
            <SafeAreaView style={styles.container}>
                <StatusBar barStyle="light-content" />
                <KeyboardAvoidingView behavior='padding' style={styles.container}>
                    <TouchableWithoutFeedback style={styles.container} onPress={Keyboard.dismiss}>
                        <View style={styles.container}>
                            <View style={styles.logoContainer}>
                                <Image style={styles.logo}
                                    source={require('../images/office.png')}>
                                </Image>
                                <Text style={styles.title}>LOGIN</Text>
                            </View>
                            <View style={styles.infoContainer}>
                                <TextInput style={styles.input}
                                    placeholder="Enter your email"
                                    placeholderTextColor="gray"
                                    keyboardType='email-address'
                                    returnKeyType='next'
                                    autoCorrect={false}
                                    onSubmitEditing={()=> this.refs.txtPassword.focus()}
                                />
                                <TextInput style={styles.input}
                                    placeholder="Enter your password"
                                    placeholderTextColor="gray"
                                    returnKeyType='go'
                                    secureTextEntry
                                    autoCorrect={false}
                                    ref={"txtPassword"}
                                />
                                <CheckBox>
                                    
                                </CheckBox>
                                <TouchableOpacity style={styles.buttonContainer}>
                                    <Text style={styles.buttonText}>Sign in</Text>
                                </TouchableOpacity>
                                <TouchableOpacity >
                                <Text style={styles.buttonText}>Forgot your password???</Text>
                                </TouchableOpacity>
                            </View>
                        </View>
                    </TouchableWithoutFeedback>
                </KeyboardAvoidingView>
            </SafeAreaView>)
    }
}
const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#FF7F50',
        flexDirection: 'column',
    },
    logoContainer: {
        alignItems: 'center',
        justifyContent: 'center',
        flex: 0.5,
        top: 100,
        bottom: 300,
    },
    logo: {
        width: 200,
        height: 40,
    },
    title: {
        color: 'yellow',
        fontSize: 16,
        textAlign: 'center',
        marginTop: 1,
        opacity: 0.5,
        top: 15,
        bottom: 50,
    },
    infoContainer: {
        position: 'absolute',
        left: 0,
        right: 0,
        top: 350,
        bottom: 100,
        height: 120,
        padding: 15,

    },
    input: {
        height: 40,
        backgroundColor: 'white',
        marginBottom: 20,
        paddingHorizontal: 10,
        borderStyle: 'solid',
        borderRadius: 10,
    },
    buttonContainer: {
        backgroundColor: 'white',
        paddingVertical: 15,
        borderRadius: 10,
    },
    buttonText: {
        textAlign: 'center',
        color: 'black',
        fontWeight: 'bold',
        fontSize: 16,
    },
})