
import * as functions from 'firebase-functions'
import * as admin from 'firebase-admin'
import * as _ from 'lodash'

admin.initializeApp()


const roles = ['user', 'admin']
const FROM_EMAIL = 'sarthaksbi@gmail.com'
const actionCodeSettings = {
	
	url: 'http://localhost:3000/verify',
	
	handleCodeInApp: true,
}

/**
 * @param userId
 * @param role ("user", "admin", "manager", "support")
 */
async function grantRole(userId: string, role: string) {
	return admin.auth().setCustomUserClaims(userId, { role: role })
}

async function sendgridEmail(email, templateId, dynamic_template_data) {
	const sgMail = require('@sendgrid/mail')
	const SENDGRID_API_KEY = functions.config().sendgriddev.api
	sgMail.setApiKey(SENDGRID_API_KEY)
	try {
		const message = {
			to: email,
			from: FROM_EMAIL,

			templateId: templateId,
			dynamic_template_data: dynamic_template_data,
		}
		const mailSent = await sgMail.send(message)
		console.log(mailSent, 'A SENDGRID EMAIL SENT')
	} catch (error) {
		console.error('error: SENDING MAIL ', error)
	}
}

exports.onCreateUser = functions.auth.user().onCreate(async (user) => {
	try {
		const userCollection = await admin
			.firestore()
			.collection('users')
			.doc(user.uid)
			.set({
				uid: user.uid,
				displayName: user.displayName,
				email: user.email,
				avatarURL: user.photoURL,
				role: 'user',
				createdAt: admin.firestore.Timestamp.now(),
				updatedAt: admin.firestore.Timestamp.now(),
			})
		console.log('USER COLLECTION CREATED', userCollection)
		await grantRole(user.uid, 'user')
		console.log('USER ROLE GRANTEDT')
		
		if (!user.emailVerified) {
			admin
				.auth()
				.generateEmailVerificationLink(user.email, actionCodeSettings)
				.then((link) => {
				
					return sendgridEmail(
						user.email,

						'd-91f898ae86bc461d8b1b1e4806022e3f',
						{
							preheader: 'confirming emails makes us feel you are real',
							header: 'Confirm your email',
							body: 'Please confirm your email by tapping on below button.',
							link: link,
							buttonText: 'Confirm Email!',
						}
					)
				})
				.catch((error) => {
					
					console.log('ERROR SENDING VERIFICATION EMAIL', error)
				})
		}
	} catch (error) {
		console.error('ERROR IN ON USER CREATION', error)
	}
})

exports.sendVerification = functions.https.onCall(async (data, context) => {
	
	if (!context.auth) {
		
		throw new functions.https.HttpsError(
			'failed-precondition',
			'The function must be called ' + 'while authenticated.'
		)
	}

	const user = await admin.auth().getUser(context.auth.uid)

	if (user.emailVerified) {
		return
	}

	return admin
		.auth()
		.generateEmailVerificationLink(user.email, actionCodeSettings)
		.then((link) => {
			
			return sendgridEmail(
				user.email,

				'd-91f898ae86bc461d8b1b1e4806022e3f',
				{
					preheader: 'confirming emails makes us feel you are real',
					header: 'Confirm your email',
					body: 'Please confirm your email by tapping on below button.',
					link: link,
					buttonText: 'Confirm Email!',
				}
			)
		})
		.catch((error) => {
			
		})
})

exports.setRole = functions.https.onCall(async (data, context) => {
	
	if (!context.auth) {
		
		throw new functions.https.HttpsError(
			'failed-precondition',
			'The function must be called ' + 'while authenticated.'
		)
	}

	
	const adminRecord = await admin.auth().getUser(context.auth.uid)

	const isAdmin = (adminRecord.customClaims as any).role === 'admin'

	if (!isAdmin) {
		
		throw new functions.https.HttpsError(
			'failed-precondition',
			'The function must be called ' + 'only by an administrator'
		)
	}

	
	const role = data.role
	const userId = data.userId

	
	if (
		!(typeof role === 'string') ||
		role.length === 0 ||
		!_.values(roles).includes(role)
	) {
		
		throw new functions.https.HttpsError(
			'invalid-argument',
			'The function must be called with ' +
				' arguments "role" containing the role to be assigned and "userId"   '
		)
	}

	
	if (!(typeof userId === 'string') || !userId) {
		
		throw new functions.https.HttpsError(
			'invalid-argument',
			'The function must be called with ' + ' Check userId Passed  '
		)
	}

	try {
		
		const user = await admin.firestore().collection('users').doc(userId).get()
		const userData = user.data()
		if (userData.role === 'admin') {
			return 'User is already admin'
		}
		
		await grantRole(userId, role)
		await admin
			.firestore()
			.collection('users')
			.doc(userId)
			.update({ role: role })
		return 'success'
	} catch (error) {
		throw new functions.https.HttpsError('aborted', 'Something went wrong')
	}
})



exports.onOrderCreate = functions.firestore
	.document('orders/{orderId}')
	.onCreate(async (snap, context) => {
		const orderData = snap.data()
		const cartData = orderData.cart

		try {
			for (const item of cartData) {
				await admin
					.firestore()
					.collection('carts')
					.doc(item.cartId)
					.update({
						deleted: true,
						ordered: true,
					})
					.then(() => console.log('cart updated', item.cartId))

				await admin
					.firestore()
					.collection('products')
					.doc(item.productId)
					.update({
						inventoryQty: admin.firestore.FieldValue.increment(-item.qty),
					})
					.then(() => console.log('product updated', item.productId))
			}
		} catch (error) {
			console.log(error)
		}
	})

exports.onOrderUpdate = functions.firestore
	.document('orders/{orderId}')
	.onUpdate(async (change, context) => {
		const prevData = change.before.data()
		const newData = change.after.data()

		if (newData === null) {
			return
		}
		if (newData.status !== 'paid' || newData.status !== 'failed') {
			return
		}
		if (newData.status === 'paid') {
			const cartData = newData.cart

			try {
				for (const item of cartData) {
					await admin
						.firestore()
						.collection('products')
						.doc(item.productId)
						.update({
							inventoryQty: admin.firestore.FieldValue.increment(-item.qty),
						})
						.then(() => console.log('product updated', item.productId))
				}
			} catch (error) {
				console.log(error)
				return
			}
		} else if (newData.status === 'failed') {
			const cartData = newData.cart

			try {
				for (const item of cartData) {
					await admin
						.firestore()
						.collection('products')
						.doc(item.productId)
						.update({
							inventoryQty: admin.firestore.FieldValue.increment(item.qty),
						})
						.then(() => console.log('product updated', item.productId))
				}
			} catch (error) {
				console.log(error)
				return
			}
		}
	})




exports.createCODOrder = functions.https.onCall(async (data, context) => {
	// Checking that the user is authenticated.
	if (!context.auth) {
		
		throw new functions.https.HttpsError(
			'failed-precondition',
			'The function must be called ' + 'while authenticated.'
		)
	}

	const userId = context.auth.uid

	const cart = data.cart
	const totalAmount = data.totalAmount
	const taxAmount = data.taxAmount
	const subTotal = data.subTotal

	console.log(data)
	try {
		const orderRef = admin.firestore().collection('orders').doc()

		const user = await admin.firestore().collection('users').doc(userId).get()
		const userData = user.data()
		const address = userData.address

		await orderRef.set({
			cart: cart,
			payment: null,
			totalAmount: totalAmount,
			taxAmount: taxAmount,
			subTotal: subTotal,
			address: address,
			razorpay_order_id: null,
			status: 'cod',
			status1: 'received',
			userId: userId,
			createdAt: admin.firestore.Timestamp.now(),
			updatedAt: admin.firestore.Timestamp.now(),
		})
		return { orderId: orderRef.id }
	} catch (error) {
		console.log(error)
		throw new functions.https.HttpsError(
			'aborted',
			'Something went wrong. Try again latter'
		)
	}
})
