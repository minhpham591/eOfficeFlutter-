import React, { Component } from 'react'
import { StyleSheet, Text, View, Image, TouchableWithoutFeedback, StatusBar, TextInput, SafeAreaView, Keyboard, TouchableOpacity, KeyboardAvoidingView, TouchableOpacityBase, CheckBox, Button } from 'react-native'
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
                                    source={require('../images/eOffice.png')}>
                                </Image>

                            </View>
                            <View style={styles.infoContainer}>
                                <TextInput style={styles.input}
                                    placeholder="Enter your email"
                                    placeholderTextColor="gray"
                                    keyboardType='email-address'
                                    returnKeyType='next'
                                    autoCorrect={false}
                                    onSubmitEditing={() => this.refs.txtPassword.focus()}
                                />
                                <TextInput style={styles.input}
                                    placeholder="Enter your password"
                                    placeholderTextColor="gray"
                                    returnKeyType='go'
                                    secureTextEntry
                                    autoCorrect={false}
                                    ref={"txtPassword"}
                                />

                                <TouchableOpacity style={styles.buttonContainer}>
                                    <Text style={styles.buttonText}>Login</Text>
                                </TouchableOpacity>

                                <TouchableOpacity style={styles.buttonContainer1}>
                                    <Text style={styles.buttonText1}>Forgot your password???</Text>
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
        backgroundColor: 'white',
        flexDirection: 'column',
    },
    logoContainer: {
        alignItems: 'center',
        justifyContent: 'center',
        flex: 0.5,
        top: 75,
        bottom: 200,
    },
    logo: {
        width: 250,
        height: 200,
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
        borderWidth: 1.5,
    },
    buttonContainer: {
        backgroundColor: 'lightblue',
        paddingVertical: 10,
        borderRadius: 10,
        left: 250,
        marginRight: 250,
    },
    buttonText: {
        textAlign: 'center',
        color: 'black',
        fontWeight: 'bold',
        fontSize: 16,

    },
    buttonContainer1: {

        paddingVertical: 10,
        borderRadius: 10,
        top: 130,

    },
    buttonText1: {
        textAlign: 'center',
        color: 'black',
        fontWeight: 'bold',
        fontSize: 16,

    },
})